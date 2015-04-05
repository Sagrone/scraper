require 'spec_helper'
require 'sagrone_scraper/base'

RSpec.describe SagroneScraper::Base do
  describe '#initialize' do
    it 'requires a "page" option' do
      expect {
        described_class.new
      }.to raise_error(SagroneScraper::Base::Error, 'Option "page" must be provided.')
    end
  end

  describe 'instance methods' do
    let(:page) { Mechanize::Page.new }
    let(:scraper) { described_class.new(page: page) }

    describe '#page' do
      it { expect(scraper.page).to be_a(Mechanize::Page) }
    end

    describe '#page_url' do
      it { expect(scraper.page_url).to be }
      it { expect(scraper.page_url).to eq page.uri.to_s }
    end

    describe '#scrape_page!' do
      it do
        expect {
          scraper.scrape_page!
        }.to raise_error(NotImplementedError, "Expected #{described_class}.can_scrape?(url) to be implemented.")
      end
    end

    describe '#attributes' do
      it { expect(scraper.attributes).to be_empty }
    end
  end

  describe 'class methods' do
    describe '.can_scrape?(url)' do
      it do
        expect {
          described_class.can_scrape?('url')
        }.to raise_error(NotImplementedError, "Expected #{described_class}.can_scrape?(url) to be implemented.")
      end
    end
  end

  describe 'create custom TwitterScraper from SagroneScraper::Base' do
    before do
      stub_request_for('https://twitter.com/Milano_JS', 'twitter.com:Milano_JS')
    end

    let(:page) { Mechanize.new.get('https://twitter.com/Milano_JS') }
    let(:twitter_scraper) { TwitterScraper.new(page: page) }
    let(:expected_attributes) do
      {
        bio: "Javascript User Group Milano #milanojs",
        location: "Milan, Italy"
      }
    end

    describe 'should be able to scrape page without errors' do
      it { expect { twitter_scraper.scrape_page! }.to_not raise_error }
    end

    it 'should have attributes present after parsing' do
      twitter_scraper.scrape_page!

      expect(twitter_scraper.attributes).to_not be_empty
      expect(twitter_scraper.attributes).to eq expected_attributes
    end

    it 'should have correct attributes event if parsing is done multiple times' do
      twitter_scraper.scrape_page!
      twitter_scraper.scrape_page!
      twitter_scraper.scrape_page!

      expect(twitter_scraper.attributes).to_not be_empty
      expect(twitter_scraper.attributes).to eq expected_attributes
    end
  end
end
