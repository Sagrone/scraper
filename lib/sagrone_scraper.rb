require "sagrone_scraper/version"

module SagroneScraper
  def self.version
    VERSION
  end

  def self.registered_parsers
    @registered_parsers || []
  end
end
