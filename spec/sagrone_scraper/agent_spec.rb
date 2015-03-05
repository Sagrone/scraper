require 'spec_helper'
require 'sagrone_scraper/agent'

RSpec.describe SagroneScraper::Agent do
  describe '.http_client' do
    subject { described_class.http_client }

    it { should be_a(Mechanize) }
    it { should respond_to(:get) }
  end
end
