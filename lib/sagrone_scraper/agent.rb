require 'mechanize'

module SagroneScraper
  class Agent
    Error = Class.new(RuntimeError)

    AGENT_ALIASES = ["Linux Firefox", "Linux Mozilla", "Mac Firefox", "Mac Mozilla", "Mac Safari", "Windows Chrome", "Windows IE 8", "Windows IE 9", "Windows Mozilla"]

    attr_reader :url, :page

    def initialize(options = {})
      @url = options.fetch(:url) do
              raise Error.new('Option "url" must be provided')
             end
      @page = http_client.get(url)
    rescue StandardError => error
      raise Error.new(error.message)
    end

    def http_client
      @http_client ||= self.class.http_client
    end

    def self.http_client
      Mechanize.new do |agent|
        agent.user_agent_alias = AGENT_ALIASES.sample
        agent.max_history = 0
      end
    end
  end
end
