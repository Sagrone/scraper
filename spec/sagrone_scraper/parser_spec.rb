require 'spec_helper'
require 'sagrone_scraper/parser'

RSpec.describe SagroneScraper::Parser do
  describe '#initialize' do
    it 'requires a "page" option' do
      expect { described_class.new }.to raise_error(SagroneScraper::Parser::Error, /Option "page" must be provided./)
    end
  end

  describe '#page' do
    let(:page) { Mechanize::Page.new }
    let(:parser) { described_class.new(page: page) }

    it { expect(parser.page).to be }
    it { expect(parser.page).to be_a(Mechanize::Page) }
  end
end
