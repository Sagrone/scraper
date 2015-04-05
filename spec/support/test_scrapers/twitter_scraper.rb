require 'sagrone_scraper/base'

class TwitterScraper < SagroneScraper::Base
  TWITTER_PROFILE_URL = /^https?:\/\/twitter.com\/(\w)+\/?$/i

  def self.can_scrape?(url)
    url.match(TWITTER_PROFILE_URL) ? true : false
  end

  def bio
    page.at('.ProfileHeaderCard-bio').text
  end

  def location
    page.at('.ProfileHeaderCard-locationText').text
  end
end
