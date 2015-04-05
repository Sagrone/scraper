require 'spec_helper'
require 'sagrone_scraper'

RSpec.describe SagroneScraper do
  describe 'self.version' do
    it { expect(SagroneScraper.version).to be_a(String) }
  end
end
