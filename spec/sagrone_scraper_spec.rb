require 'spec_helper'
require 'sagrone_scraper'

RSpec.describe SagroneScraper do
  describe '.version' do
    it { expect(SagroneScraper.version).to be_a(String) }
  end

  context 'scrapers registered' do
    before do
      described_class.registered_scrapers.clear
    end

    describe '.registered_scrapers' do
      it { expect(described_class.registered_scrapers).to be_empty }
      it { expect(described_class.registered_scrapers).to be_a(Array) }
    end

    describe '.register_scraper(name)' do
      it 'should add a new scraper class to registered scrapers automatically' do
        class ScraperOne < SagroneScraper::Base ; end
        class ScraperTwo < SagroneScraper::Base ; end

        expect(described_class.registered_scrapers).to include('ScraperOne')
        expect(described_class.registered_scrapers).to include('ScraperTwo')
        expect(described_class.registered_scrapers.size).to eq(2)
      end

      it 'should check scraper name is an existing constant' do
        expect {
          described_class.register_scraper('Unknown')
        }.to raise_error(NameError, 'uninitialized constant Unknown')
      end

      it 'should check scraper class inherits from SagroneScraper::Base' do
        NotScraper = Class.new

        expect {
          described_class.register_scraper('NotScraper')
        }.to raise_error(SagroneScraper::Error, 'Expected scraper to be a SagroneScraper::Base.')
      end

      it 'should register multiple scrapers only once' do
        class TestScraper < SagroneScraper::Base ; end

        described_class.register_scraper('TestScraper')
        described_class.register_scraper('TestScraper')

        expect(described_class.registered_scrapers).to include('TestScraper')
        expect(described_class.registered_scrapers.size).to eq 1
      end
    end
  end

  describe '.scrape' do
    before do
      SagroneScraper.registered_scrapers.clear
      SagroneScraper.register_scraper('TwitterScraper')

      stub_request_for('https://twitter.com/Milano_JS', 'twitter.com:Milano_JS')
    end

    it 'should `url` option' do
      expect {
        described_class.scrape({})
      }.to raise_error(SagroneScraper::Error, 'Option "url" must be provided.')
    end

    it 'should scrape URL if registered scraper knows how to parse it' do
      expected_attributes = {
        bio: "Javascript User Group Milano #milanojs",
        location: "Milan, Italy"
      }

      expect(described_class.scrape(url: 'https://twitter.com/Milano_JS')).to eq(expected_attributes)
    end

    it 'should return raise error if no registered paser can parse the URL' do
      expect {
        described_class.scrape(url: 'https://twitter.com/Milano_JS/media')
      }.to raise_error(SagroneScraper::Error, "No registed scraper can parse URL https://twitter.com/Milano_JS/media")
    end
  end
end
