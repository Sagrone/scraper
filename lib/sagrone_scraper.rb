require "sagrone_scraper/version"
require "sagrone_scraper/agent"
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

  def self.scrape(options)
    url = options.fetch(:url) do
            raise Error.new('Option "url" must be provided.')
          end

    parser_class = registered_parsers
                    .map { |parser_name| Object.const_get(parser_name) }
                    .find { |a_parser_class| a_parser_class.can_parse?(url) }

    raise Error.new("No registed parser can parse URL #{url}") unless parser_class

    agent = SagroneScraper::Agent.new(url: url)
    parser = parser_class.new(page: agent.page)
    parser.parse_page!
    parser.attributes
  end
end
