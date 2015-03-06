require 'mechanize'

module SagroneScraper
  class Agent
    AGENT_ALIASES = ["Linux Firefox", "Linux Mozilla", "Mac Firefox", "Mac Mozilla", "Mac Safari", "Windows Chrome", "Windows IE 8", "Windows IE 9", "Windows Mozilla"]

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def page
      @page ||= http_client.get(url)
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
