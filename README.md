# SagroneScraper

Simple library to scrap web pages. Bellow you will find information on [how to use it](#usage).

## Installation

Add this line to your application's Gemfile:

    $ gem 'sagrone_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sagrone_scraper

## Usage

#### `SagroneScraper::Agent`

The agent is responsible for scraping a web page from a URL.

Here is how you can create an `agent`:

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


## Contributing

1. Fork it ( https://github.com/[my-github-username]/sagrone_scraper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
