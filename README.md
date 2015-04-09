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
    * [Create a scraper class](#create-a-scraper-class)
    * [Instantiate the scraper](#instantiate-the-scraper)
    * [Scrape the page](#scrape-the-page)
    * [Extract the data](#extract-the-data)
  + [`SagroneScraper::Collection`](#sagronescrapercollection)

## Installation

Add this line to your application's Gemfile:

    $ gem 'sagrone_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sagrone_scraper

## Basic Usage

In order to _scrape a web page_ you will need to:

1. [create a new scraper class](#create-a-scraper-class) by inheriting from `SagroneScraper::Base`, and
2. [instantiate it with a `url` or `page`](#instantiate-the-scraper)
3. then you can use the scraper instance to [scrape the page](#scrape-the-page) and [extract structured data](#extract-the-data)

More informations at [`SagroneScraper::Base`](#sagronescraperbase) module.

## Modules

### `SagroneScraper::Agent`

The agent is responsible for obtaining a page, `Mechanize::Page`, from a URL. Here is how you can create an `agent`:

```ruby
require 'sagrone_scraper'

agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')
agent.page
# => Mechanize::Page

agent.page.at('.ProfileHeaderCard-bio').text
# => "Javascript User Group Milano #milanojs"
```

### `SagroneScraper::Base`

Here we define a `TwitterScraper`, by inheriting from `SagroneScraper::Base` class.

The _scraper_ is responsible for extracting structured data from a _page_ or a _url_. The _page_ can be obtained by the [_agent_](#sagronescraperagent).

_Public_ instance methods will be used to extract data, whereas _private_ instance methods will be ignored (seen as helper methods). Most importantly `self.can_scrape?(url)` class method ensures that only a known subset of pages can be scraped for data.

#### Create a scraper class

```ruby
require 'sagrone_scraper'

class TwitterScraper < SagroneScraper::Base
  TWITTER_PROFILE_URL = /^https?:\/\/twitter.com\/(\w)+\/?$/i

  def self.can_scrape?(url)
    url.match(TWITTER_PROFILE_URL) ? true : false
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
```

#### Instantiate the scraper

```ruby
# Instantiate the scraper with a "url".
scraper = TwitterScraper.new(url: 'https://twitter.com/Milano_JS')

# Instantiate the scraper with a "page" (Mechanize::Page).
agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')
scraper = TwitterScraper.new(page: agent.page)
```

#### Scrape the page

```ruby
scraper.scrape_page!
```

#### Extract the data

```ruby
scraper.attributes
# => {bio: "Javascript User Group Milano #milanojs", location: "Milan, Italy"}
```

### `SagroneScraper::Collection`

This is the simplest way to scrape a web page:

```ruby
require 'sagrone_scraper'

# 1) Define a scraper. For example, the TwitterScraper above.

# 2) New created scrapers will be registered.
SagroneScraper.Collection::registered_scrapers
# => ['TwitterScraper']

# 3) Here we use the collection to scrape data at a URL.
SagroneScraper::Collection.scrape(url: 'https://twitter.com/Milano_JS')
# => {bio: "Javascript User Group Milano #milanojs", location: "Milan, Italy"}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sagrone_scraper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
