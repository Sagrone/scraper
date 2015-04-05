# Sagrone scraper

[![Gem Version](https://badge.fury.io/rb/sagrone_scraper.svg)](http://badge.fury.io/rb/sagrone_scraper)
[![Build Status](https://travis-ci.org/Sagrone/scraper.svg?branch=master)](https://travis-ci.org/Sagrone/scraper)

Simple library to scrap web pages. Bellow you will find information on [how to use it](#basic-usage).

## Table of Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Modules](#modules)
  + [`SagroneScraper::Agent`](#sagronescraperagent)
  + [`SagroneScraper::Base`](#sagronescraperbase)
  + [`SagroneScraper::Collection.scrape`](#sagronescrapercollectionscrape)

## Installation

Add this line to your application's Gemfile:

    $ gem 'sagrone_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sagrone_scraper

## Basic Usage

Comming soon...

## Modules

#### `SagroneScraper::Agent`

The agent is responsible for obtaining a page, `Mechanize::Page`, from a URL. Here is how you can create an `agent`:

```ruby
require 'sagrone_scraper'

agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')
agent.page
# => Mechanize::Page

agent.page.at('.ProfileHeaderCard-bio').text
# => "Javascript User Group Milano #milanojs"
```

#### `SagroneScraper::Base`

Here we define a `TwitterScraper`, by inheriting from `SagroneScraper::Base` class.

The _scraper_ is responsible for extracting structured data from a _page_ or a _url_. The _page_ can be obtained by the [_agent_](#sagronescraperagent).

_Public_ instance methods will be used to extract data, whereas _private_ instance methods will be ignored (seen as helper methods). Most importantly `self.can_scrape?(url)` class method ensures that only a known subset of pages can be scraped for data.

```ruby
require 'sagrone_scraper'

# 1) Create a scraper class.
class TwitterScraper < SagroneScraper::Base
  TWITTER_PROFILE_URL = /^https?:\/\/twitter.com\/(\w)+\/?$/i

  def self.can_scrape?(url)
    url.match(TWITTER_PROFILE_URL)
  end

  # Public instance methods are used for data extraction.

  def bio
    text_at('.ProfileHeaderCard-bio')
  end

  def location
    text_at('.ProfileHeaderCard-locationText')
  end

  private

  # Private instance methods are not used for data extraction.

  def text_at(selector)
    page.at(selector).text if page.at(selector)
  end
end

# 2a) Instantiate the scraper with a "url".
scraper = TwitterScraper.new(url: 'https://twitter.com/Milano_JS')

# 2b) Instantiate the scraper with a "page" (Mechanize::Page).
agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')
scraper = TwitterScraper.new(page: agent.page)

# 3) Scrape the page and extract attributes.
scraper.scrape_page!

# 4) Extract the data.
scraper.attributes
# => {bio: "Javascript User Group Milano #milanojs", location: "Milan, Italy"}
```

#### `SagroneScraper::Collection.scrape`

This is the simplest way to scrape a web page:

```ruby
require 'sagrone_scraper'

# 1) Define a scraper. For example, the TwitterScraper above.

# 2) We can query for registered scrapers.
SagroneScraper.Collection::registered_scrapers
# => ['TwitterScraper']

# 3) We can now scrape twitter profile URLs.
SagroneScraper::Collection.scrape(url: 'https://twitter.com/Milano_JS')
# => {bio: "Javascript User Group Milano #milanojs", location: "Milan, Italy"}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sagrone_scraper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
