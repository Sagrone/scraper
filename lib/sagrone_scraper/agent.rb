require 'mechanize'

module SagroneScraper
  class Agent
    def self.http_client
      Mechanize.new do |agent|
        agent.max_history = 0
      end
    end
  end
end
