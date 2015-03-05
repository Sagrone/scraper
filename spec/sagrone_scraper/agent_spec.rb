require 'spec_helper'
require 'sagrone_scraper/agent'

RSpec.describe SagroneScraper::Agent do
  describe '.http_client' do
    it { expect(described_class.http_client).to be_a(Mechanize) }
    it { expect(described_class.http_client).to respond_to(:get) }
  end
end
