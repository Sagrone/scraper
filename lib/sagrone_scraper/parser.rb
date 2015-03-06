require 'mechanize'

module SagroneScraper
  class Parser
    Error = Class.new(RuntimeError)

    attr_reader :page, :attributes

    def initialize(options = {})
      @page = options.fetch(:page) do
                raise Error.new('Option "page" must be provided.')
              end
      @attributes = {}
    end

    def parse_page!
      nil
    end
  end
end
