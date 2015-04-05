require 'mechanize'
require 'sagrone_scraper'

module SagroneScraper
  class Base
    Error = Class.new(RuntimeError)

    attr_reader :page, :url, :attributes

    def initialize(options = {})
      raise Error.new('Exactly one option must be provided: "url" or "page"') unless exactly_one_of(options)

      @url, @page = options[:url], options[:page]

      @url ||= page_url
      @page ||= Agent.new(url: url).page
      @attributes = {}
    end

    def scrape_page!
      return unless self.class.can_scrape?(page_url)

      self.class.method_names.each do |name|
        attributes[name] = send(name)
      end
      nil
    end

    def self.can_scrape?(url)
      class_with_method = "#{self}.can_scrape?(url)"
      raise NotImplementedError.new("Expected #{class_with_method} to be implemented.")
    end

    def self.should_ignore_method?(name)
      private_method_defined?(name)
    end

    private

    def exactly_one_of(options)
      url_present = !!options[:url]
      page_present = !!options[:page]

      (url_present && !page_present) || (!url_present && page_present)
    end

    def page_url
      @page.uri.to_s
    end

    def self.method_names
      @method_names ||= []
    end

    def self.method_added(name)
      method_names.push(name) unless should_ignore_method?(name)
    end

    def self.inherited(klass)
      SagroneScraper::Collection.register_scraper(klass.name)
    end
  end
end
