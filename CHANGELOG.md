### HEAD

### 0.1.0

- simplify library entities:
  - `SagroneScraper::Parser` is now `SagroneScraper::Base`
  - `SagroneScraper::Base` is base class to create new scrapers
  - `SagroneScraper.registered_parsers` is now `SagroneScraper.registered_scrapers`
  - `SagroneScraper.register_parser` is now `SagroneScraper.register_scraper`
  - `SagroneScraper::Base.parse_page!` renamed to `SagroneScraper::Base.scrape_page!`
  - `SagroneScraper::Base.can_parse?` renamed to `SagroneScraper::Base.can_scrape?`
  - `SagroneScraper::Base` _private_ instance methods are not used for extracting data, only _public_ instance methods are.
- `SagroneScraper::Collection`:
  - registeres new created scrappers automatically
  - knows how to scrape a page from a generic URL (if there is a valid scraper for that URL)
- `SagroneScraper::Base` takes exactly one of `url` or `page` options
- `SagroneScraper::Agent` takes only a `url` option

### 0.0.3

- add `SagroneScraper::Parser.can_parse?(url)` class method, which must be  implemented in subclasses
- add `SagroneScraper` logic to _scrape_ a URL based on a set of _registered parsers_

### 0.0.2

- add `SagroneScraper::Parser`

### 0.0.1

- add `SagroneScraper::Agent`
