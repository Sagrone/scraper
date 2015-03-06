require 'spec_helper'
require 'sagrone_scraper/parser'

RSpec.describe SagroneScraper::Parser do
  describe '#initialize' do
    it 'requires a "page" option' do
      expect { described_class.new }.to raise_error(SagroneScraper::Parser::Error, /Option "page" must be provided./)
    end
  end
end
