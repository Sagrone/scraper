require 'mechanize'

module SagroneScraper
  class Agent
    AGENT_ALIASES = ["Linux Firefox", "Linux Mozilla", "Mac Firefox", "Mac Mozilla", "Mac Safari", "Windows Chrome", "Windows IE 8", "Windows IE 9", "Windows Mozilla"]

    def self.http_client
      Mechanize.new do |agent|
        agent.user_agent_alias = AGENT_ALIASES.sample
        agent.max_history = 0
      end
    end
  end
end
