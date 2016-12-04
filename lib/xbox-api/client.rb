module XboxApi

  class Client

    attr_reader :api_key, :base_url

    def initialize(api_key)
      @api_key = api_key
      @base_url = "https://xboxapi.com/v2"
      @last_headers = nil
    end

    def gamer(tag)
      XboxApi::Gamer.new(tag, self)
    end

    def game(id)
      XboxApi::Game.new(id, self)
    end

    def fetch_body_and_parse(endpoint)
      response = get_with_token(endpoint)
      @last_headers = parse_headers(response.meta)
      parse(response.read)
    end

    def calls_remaining(cached = false)
      if cached && !@last_headers.nil?
        @last_headers
      else
        parse_headers(fetch_headers)
      end
    end

    private

    def parse_headers(meta)
      {
          limit: meta['x-ratelimit-limit'],
          remaining: meta['x-ratelimit-remaining'],
          resets_in: meta['x-ratelimit-reset']
      }
    end

    def parse(json)
      Yajl::Parser.parse(json, symbolize_keys: true)
    end

    def get_with_token(endpoint)
      request = URI.parse("#{base_url}/#{endpoint}")
      open(request, "X-AUTH" => api_key, "User-Agent" => "Ruby/XboxApi Gem v#{XboxApi::Wrapper::VERSION}")
    end

    def fetch_headers
      get_with_token("accountXuid").meta
    end

  end

end
