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
    describe 'with valid url' do
      before do
        stub_request_for('http://example.com', 'www.example.com')
      end

      let(:agent) { described_class.new('http://example.com') }

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
