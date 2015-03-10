require 'spec_helper'
require 'sagrone_scraper'

RSpec.describe SagroneScraper do
  describe '.version' do
    it { expect(SagroneScraper.version).to be_a(String) }
  end

  context 'parsers registered' do
    before do
      described_class.registered_parsers.clear
    end

    describe '.registered_parsers' do
      it { expect(described_class.registered_parsers).to be_empty }
      it { expect(described_class.registered_parsers).to be_a(Array) }
    end

    describe '.register_parser(name)' do
      TestParser = Class.new(SagroneScraper::Parser)
      NotParser = Class.new

      it 'should check parser name is an existing constant' do
        expect {
          described_class.register_parser('Unknown')
        }.to raise_error(NameError, 'uninitialized constant Unknown')
      end

      it 'should check parser class inherits from SagroneScraper::Parser' do
        expect {
          described_class.register_parser('NotParser')
        }.to raise_error(SagroneScraper::Error, 'Expected parser to be a SagroneScraper::Parser.')
      end

      it 'after adding a "parser" should have it registered' do
        described_class.register_parser('TestParser')

        expect(described_class.registered_parsers).to include('TestParser')
        expect(described_class.registered_parsers.size).to eq 1
      end

      it 'adding same "parser" multiple times should register it once' do
        described_class.register_parser('TestParser')
        described_class.register_parser('TestParser')

        expect(described_class.registered_parsers).to include('TestParser')
        expect(described_class.registered_parsers.size).to eq 1
      end
    end
  end

  describe '.scrape(url)' do
    before do
      SagroneScraper.registered_parsers.clear
      SagroneScraper.register_parser('TwitterParser')

      stub_request_for('https://twitter.com/Milano_JS', 'twitter.com:Milano_JS')
    end

    it do
      expected_attributes = {
        bio: "Javascript User Group Milano #milanojs",
        location: "Milan, Italy"
      }

      expect(described_class.scrape('https://twitter.com/Milano_JS')).to eq(expected_attributes)
    end
  end
end
