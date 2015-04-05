require 'mechanize'
require 'sagrone_scraper'

module SagroneScraper
  class Base
    Error = Class.new(RuntimeError)

    attr_reader :page, :page_url, :attributes

    def initialize(options = {})
      @page = options.fetch(:page) do
                raise Error.new('Option "page" must be provided.')
              end
      @page_url = @page.uri.to_s
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

    private

    def self.method_names
      @method_names ||= []
    end

    def self.method_added(name)
      method_names.push(name)
    end

    def self.inherited(klass)
      SagroneScraper.register_scraper(klass.name)
    end
  end
end