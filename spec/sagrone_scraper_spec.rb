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
      Test = Class.new

      it 'should check parser name is an existing constant' do
        expect {
          described_class.register_parser('Unknown')
        }.to raise_error(NameError, 'uninitialized constant Unknown')
      end

      it 'after adding a "parser" should have it registered' do
        described_class.register_parser('Test')

        expect(described_class.registered_parsers).to include('Test')
        expect(described_class.registered_parsers.size).to eq 1
      end

      it 'adding same "parser" multiple times should register it once' do
        described_class.register_parser('Test')
        described_class.register_parser('Test')

        expect(described_class.registered_parsers).to include('Test')
        expect(described_class.registered_parsers.size).to eq 1
      end
    end
  end
end
