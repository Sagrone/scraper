require 'spec_helper'
require 'sagrone_scraper'

RSpec.describe SagroneScraper do
  describe '.version' do
    it { expect(SagroneScraper.version).to be_a(String) }
  end

  describe '.registered_parsers' do
    it { expect(described_class.registered_parsers).to be_empty }
    it { expect(described_class.registered_parsers).to be_a(Array) }
  end
end
