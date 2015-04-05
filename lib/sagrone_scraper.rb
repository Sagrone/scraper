require "sagrone_scraper/version"
require "sagrone_scraper/agent"
require "sagrone_scraper/base"

module SagroneScraper
  Error = Class.new(RuntimeError)

  def self.version
    VERSION
  end

  def self.registered_scrapers
    @registered_scrapers ||= []
  end

  def self.register_scraper(name)
    return if registered_scrapers.include?(name)

    scraper_class = Object.const_get(name)
    raise Error.new("Expected scraper to be a SagroneScraper::Base.") unless scraper_class.ancestors.include?(SagroneScraper::Base)

    registered_scrapers.push(name)
    nil
  end

  def self.scrape(options)
    url = options.fetch(:url) do
            raise Error.new('Option "url" must be provided.')
          end

    scraper_class = registered_scrapers
                    .map { |scraper_name| Object.const_get(scraper_name) }
                    .find { |a_scraper_class| a_scraper_class.can_parse?(url) }

    raise Error.new("No registed scraper can parse URL #{url}") unless scraper_class

    agent = SagroneScraper::Agent.new(url: url)
    scraper = scraper_class.new(page: agent.page)
    scraper.parse_page!
    scraper.attributes
  end
end
