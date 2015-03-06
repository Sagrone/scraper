# Sagrone scraper

[![Gem Version](https://badge.fury.io/rb/sagrone_scraper.svg)](http://badge.fury.io/rb/sagrone_scraper)
[![Build Status](https://travis-ci.org/Sagrone/scraper.svg?branch=master)](https://travis-ci.org/Sagrone/scraper)

Simple library to scrap web pages. Bellow you will find information on [how to use it](#basic-usage).

## Table of Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Modules](#modules)
  + [`SagroneScraper::Agent`](#sagronescraperagent)
  + [`SagroneScraper::Parser`](#sagronescraperparser)

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

The agent is responsible for scraping a web page from a URL. Here is how you can create an `agent`:

1. one way is to pass it a `url` option

    ```ruby
    require 'sagrone_scraper/agent'

    agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')
    agent.page
    # => Mechanize::Page

    agent.page.at('.ProfileHeaderCard-bio').text
    # => "Javascript User Group Milano #milanojs"
    ```

2. another way is to pass a `page` option (`Mechanize::Page`)

    ```ruby
    require 'sagrone_scraper/agent'

    mechanize_agent = Mechanize.new { |agent| agent.user_agent_alias = 'Linux Firefox' }
    page = mechanize_agent.get('https://twitter.com/Milano_JS')
    # => Mechanize::Page

    agent = SagroneScraper::Agent.new(page: page)
    agent.url
    # => "https://twitter.com/Milano_JS"

    agent.page.at('.ProfileHeaderCard-locationText').text
    # => "Milan, Italy"
    ```

#### `SagroneScraper::Parser`

The _parser_ is responsible for extracting structured data from a _page_. The page can be obtained by the _agent_.

Example usage:

```ruby
require 'sagrone_scraper/agent'
require 'sagrone_scraper/parser'

# 1) First define a custom parser, for example twitter.
class TwitterParser < SagroneScraper::Parser
  def bio
    page.at('.ProfileHeaderCard-bio').text
  end

  def location
    page.at('.ProfileHeaderCard-locationText').text
  end
end

# 2) Create an agent scraper, which will give us the page to parse.
agent = SagroneScraper::Agent.new(url: 'https://twitter.com/Milano_JS')

# 3) Instantiate the parser.
parser = TwitterParser.new(page: agent.page)

# 4) Parse page and extract attributes.
parser.parse_page!
parser.attributes
# => {bio: "Javascript User Group Milano #milanojs", location: "Milan, Italy"}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sagrone_scraper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
