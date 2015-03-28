require 'sagrone_scraper/base'

class TwitterScraper < SagroneScraper::Base
  TWITTER_PROFILE_URL = /^https?:\/\/twitter.com\/(\w)+\/?$/i

  def self.can_scrape?(url)
    url.match(TWITTER_PROFILE_URL) ? true : false
  end

  def bio
    text_at('.ProfileHeaderCard-bio')
  end

  def location
    text_at('.ProfileHeaderCard-locationText')
  end

  private

  def text_at(selector)
    page.at(selector).text if page.at(selector)
  end
end
