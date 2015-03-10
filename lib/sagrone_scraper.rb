require "sagrone_scraper/version"

module SagroneScraper
  def self.version
    VERSION
  end

  def self.registered_parsers
    @registered_parsers ||= []
  end

  def self.register_parser(name)
    return if registered_parsers.include?(name)
    return unless Object.const_get(name)

    registered_parsers.push(name)
  end
end
