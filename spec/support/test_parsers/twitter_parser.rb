require 'sagrone_scraper/parser'

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
