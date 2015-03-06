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
      self.class.method_names.each do |name|
        attributes[name] = send(name)
      end
      nil
    end

    private

    def self.method_names
      @method_names ||= []
    end

    def self.method_added(name)
      puts "added #{name} to #{self}"
      method_names.push(name)
    end
  end
end
