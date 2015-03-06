require 'mechanize'

module SagroneScraper
  class Parser
    Error = Class.new(RuntimeError)

    attr_reader :page

    def initialize(options = {})
      @page = options.fetch(:page) do
                raise Error.new('Option "page" must be provided.')
              end
    end

    def parse_page!
      nil
    end
  end
end
