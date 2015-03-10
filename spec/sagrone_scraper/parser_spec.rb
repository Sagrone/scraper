require 'spec_helper'
require 'sagrone_scraper/parser'

RSpec.describe SagroneScraper::Parser do
  describe '#initialize' do
    it 'requires a "page" option' do
      expect { described_class.new }.to raise_error(SagroneScraper::Parser::Error, /Option "page" must be provided./)
    end
  end

  describe 'instance methods' do
    let(:page) { Mechanize::Page.new }
    let(:parser) { described_class.new(page: page) }

    describe '#page' do
      it { expect(parser.page).to be_a(Mechanize::Page) }
    end

    describe '#page_url' do
      it { expect(parser.page_url).to be }
      it { expect(parser.page_url).to eq page.uri.to_s }
    end

    describe '#parse_page!' do
      it do
        expect {
          parser.parse_page!
        }.to raise_error(NotImplementedError, "Expected #{described_class}.can_parse?(url) to be implemented.")
      end
    end

    describe '#attributes' do
      it { expect(parser.attributes).to be_empty }
    end
  end

  describe 'class methods' do
    describe '.can_parse?(url)' do
      it do
        expect {
          described_class.can_parse?('url')
        }.to raise_error(NotImplementedError, "Expected #{described_class}.can_parse?(url) to be implemented.")
      end
    end
  end

  describe 'create custom TwitterParser from SagroneScraper::Parser' do
    class TwitterParser < SagroneScraper::Parser
      TWITTER_PROFILE_URL = /^https?:\/\/twitter.com\/(\w)+\/?$/i

      def self.can_parse?(url)
        url.match(TWITTER_PROFILE_URL)
      end

      def bio
        page.at('.ProfileHeaderCard-bio').text
      end

      def location
        page.at('.ProfileHeaderCard-locationText').text
      end
    end

    before do
      stub_request_for('https://twitter.com/Milano_JS', 'twitter.com:Milano_JS')
    end

    let(:page) { Mechanize.new.get('https://twitter.com/Milano_JS') }
    let(:twitter_parser) { TwitterParser.new(page: page) }
    let(:expected_attributes) do
      {
        bio: "Javascript User Group Milano #milanojs",
        location: "Milan, Italy"
      }
    end

    describe 'should be able to parse page without errors' do
      it { expect { twitter_parser.parse_page! }.to_not raise_error }
    end

    it 'should have attributes present after parsing' do
      twitter_parser.parse_page!

      expect(twitter_parser.attributes).to_not be_empty
      expect(twitter_parser.attributes).to eq expected_attributes
    end

    it 'should have correct attributes event if parsing is done multiple times' do
      twitter_parser.parse_page!
      twitter_parser.parse_page!
      twitter_parser.parse_page!

      expect(twitter_parser.attributes).to_not be_empty
      expect(twitter_parser.attributes).to eq expected_attributes
    end
  end
end
