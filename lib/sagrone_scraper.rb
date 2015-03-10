require "sagrone_scraper/version"
require "sagrone_scraper/parser"

module SagroneScraper
  Error = Class.new(RuntimeError)

  def self.version
    VERSION
  end

  def self.registered_parsers
    @registered_parsers ||= []
  end

  def self.register_parser(name)
    return if registered_parsers.include?(name)

    parser_class = Object.const_get(name)
    raise Error.new("Expected parser to be a SagroneScraper::Parser.") unless parser_class.ancestors.include?(SagroneScraper::Parser)

    registered_parsers.push(name)
  end
end
