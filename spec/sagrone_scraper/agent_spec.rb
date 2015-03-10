require 'spec_helper'
require 'sagrone_scraper/agent'

RSpec.describe SagroneScraper::Agent do
  let(:user_agent_aliases) do
    [ "Linux Firefox", "Linux Mozilla",
      "Mac Firefox", "Mac Mozilla", "Mac Safari",
      "Windows Chrome", "Windows IE 8", "Windows IE 9", "Windows Mozilla" ]
  end

  describe 'AGENT_ALIASES' do
    it { expect(described_class::AGENT_ALIASES).to eq(user_agent_aliases) }
  end

  describe '.http_client' do
    subject { described_class.http_client }

    it { should be_a(Mechanize) }
    it { should respond_to(:get) }
    it { expect(subject.user_agent).to match(/Mozilla\/5\.0/) }
  end

  describe '#initialize' do
    describe 'should require exactly one of `url` or `page` option' do
      before do
        stub_request_for('http://example.com', 'www.example.com')
      end

      it 'when options is empty' do
        expect {
          described_class.new
        }.to raise_error(SagroneScraper::Agent::Error,
                          'Exactly one option must be provided: "url" or "page"')
      end

      it 'when both options are present' do
        page = Mechanize.new.get('http://example.com')

        expect {
          described_class.new(url: 'http://example.com', page: page)
        }.to raise_error(SagroneScraper::Agent::Error,
                          'Exactly one option must be provided: "url" or "page"')
      end
    end

    describe 'with page option' do
      before do
        stub_request_for('http://example.com', 'www.example.com')
      end

      let(:page) { Mechanize.new.get('http://example.com') }
      let(:agent) { described_class.new(page: page) }

      it { expect { agent }.to_not raise_error }
      it { expect(agent.page).to be }
      it { expect(agent.url).to eq 'http://example.com/' }
    end

    describe 'with invalid URL' do
      let(:agent) { described_class.new(url: @invalid_url) }

      it 'should require URL is absolute' do
        @invalid_url = 'not-a-url'

        expect { agent }.to raise_error(SagroneScraper::Agent::Error,
                                        'absolute URL needed (not not-a-url)')
      end

      it 'should require absolute path' do
        @invalid_url = 'http://'

        webmock_allow do
          expect { agent }.to raise_error(SagroneScraper::Agent::Error,
                                          /bad URI\(absolute but no path\)/)
        end
      end

      it 'should require valid URL' do
        @invalid_url = 'http://example'

        webmock_allow do
          expect { agent }.to raise_error(SagroneScraper::Agent::Error,
                                          /getaddrinfo/)
        end
      end
    end

    describe 'with valid URL' do
      before do
        stub_request_for('http://example.com', 'www.example.com')
      end

      let(:agent) { described_class.new(url: 'http://example.com') }

      it { expect(agent.http_client).to be_a(Mechanize) }
      it { expect(agent.http_client).to equal(agent.http_client) }

      it { expect { agent }.to_not raise_error }
      it { expect(agent.url).to eq('http://example.com') }

      it { expect(agent.page).to be_a(Mechanize::Page) }
      it { expect(agent.page).to equal(agent.page) }
      it { expect(agent.page).to respond_to(:at, :body, :title) }
      it { expect(agent.page).to respond_to(:links, :labels, :images, :image_urls, :forms) }
    end
  end
end
