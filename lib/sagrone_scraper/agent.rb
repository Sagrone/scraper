require 'mechanize'

module SagroneScraper
  class Agent
    Error = Class.new(RuntimeError)

    AGENT_ALIASES = ["Linux Firefox", "Linux Mozilla", "Mac Firefox", "Mac Mozilla", "Mac Safari", "Windows Chrome", "Windows IE 8", "Windows IE 9", "Windows Mozilla"]

    attr_reader :url, :page

    def initialize(options = {})
      raise Error.new('Exactly one option must be provided: "url" or "page"') unless exactly_one_of(options)

      @url, @page = options[:url], options[:page]

      @url ||= page_url
      @page ||= http_client.get(url)
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

    private

    def page_url
      @page.uri.to_s
    end

    def exactly_one_of(options)
      url_present = !!options[:url]
      page_present = !!options[:page]

      (url_present && !page_present) || (!url_present && page_present)
    end
  end
end
