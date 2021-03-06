module XboxApi
  class Game
    attr_reader :id

    def initialize(id, client)
      @client = client
      @id = id
    end

    def details
      endpoint = "game-details-hex/#{@id}"
      client.fetch_body_and_parse(endpoint)
    end

    private

    attr_reader :client
  end

end
