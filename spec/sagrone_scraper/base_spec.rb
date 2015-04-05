require 'spec_helper'
require 'sagrone_scraper/base'

RSpec.describe SagroneScraper::Base do
  describe '#initialize' do
    before do
      stub_request_for('http://example.com', 'www.example.com')
    end

    describe 'should require exactly one of `url` or `page` option' do
      it 'when options is empty' do
        expect {
          described_class.new
        }.to raise_error(described_class::Error,
                          'Exactly one option must be provided: "url" or "page"')
      end

      it 'when both options are present' do
        page = Mechanize.new.get('http://example.com')

        expect {
          described_class.new(url: 'http://example.com', page: page)
        }.to raise_error(described_class::Error,
                          'Exactly one option must be provided: "url" or "page"')
      end
    end

    describe 'with page option' do
      let(:page) { Mechanize.new.get('http://example.com') }
      let(:agent) { described_class.new(page: page) }

      it { expect { agent }.to_not raise_error }
      it { expect(agent.page).to be }
      it { expect(agent.url).to eq 'http://example.com/' }
    end

    describe 'with url option' do
      let(:agent) { described_class.new(url: 'http://example.com') }

      it { expect { agent }.to_not raise_error }
      it { expect(agent.page).to be }
      it { expect(agent.url).to eq 'http://example.com' }
    end
  end

  describe 'instance methods' do
    let(:page) { Mechanize::Page.new }
    let(:scraper) { described_class.new(page: page) }

    describe '#page' do
      it { expect(scraper.page).to be_a(Mechanize::Page) }
    end

    describe '#url' do
      it { expect(scraper.url).to eq page.uri.to_s }
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
    let(:page) { Mechanize.new.get('https://twitter.com/Milano_JS') }
    let(:twitter_scraper) { TwitterScraper.new(page: page) }

    describe 'self.can_scrape?(url)' do
      it 'must be implemented in subclasses' do
        expect {
          described_class.can_scrape?('url')
        }.to raise_error(NotImplementedError, "Expected #{described_class}.can_scrape?(url) to be implemented.")
      end
    end

    describe 'example TwitterScraper' do
      describe 'self.can_scrape?(url)' do
        it 'should be true for scrapable URLs' do
          can_scrape = TwitterScraper.can_scrape?('https://twitter.com/Milano_JS')

          expect(can_scrape).to eq(true)
        end

        it 'should be false for unknown URLs' do
          can_scrape = TwitterScraper.can_scrape?('https://www.facebook.com/milanojavascript')

          expect(can_scrape).to eq(false)
        end
      end

      describe 'self.should_ignore_method?(name)' do
        let(:private_methods) { %w(text_at) }
        let(:public_methods) { %w(bio location) }

        it 'ignores private methods' do
          private_methods.each do |private_method|
            ignored = TwitterScraper.should_ignore_method?(private_method)

            expect(ignored).to eq(true)
          end
        end

        it 'allows public methods' do
          public_methods.each do |public_method|
            ignored = TwitterScraper.should_ignore_method?(public_method)

            expect(ignored).to eq(false)
          end
        end
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

    it 'should have correct attributes even if parsing is done multiple times' do
      twitter_scraper.scrape_page!
      twitter_scraper.scrape_page!
      twitter_scraper.scrape_page!

      expect(twitter_scraper.attributes).to_not be_empty
      expect(twitter_scraper.attributes).to eq expected_attributes
    end
  end
end
