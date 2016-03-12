# Wedding Registry Scraper

## Why?

Want to consolidate multiple registries onto one website?

Want to regularly update your fulfillment counts?

This (work in progress) is for you!

## Which Registries?

Right now, works with:

* Zola &mdash; https://www.zola.com
* REI &mdash; http://www.rei.com
* Heath Ceramics &mdash; http://www.heathceramics.com
* Crate &amp; Barrel &mdash; http://www.crateandbarrel.com
* Williams Sonoma &mdash; http://www.williams-sonoma.com

I intend to get this working with:

* Sur la Table
* Pottery Barn

## Getting Raw Registry Data

Add to your Gemfile

```ruby
gem 'wedding-registry-scraper'
```

Use `WeddingRegistryScraper#scrape`:

```ruby
require 'wedding_registry_scraper'

WeddingRegistryScraper.scrape([
  "http://www.heathceramics.com/giftregistry/view/index/id/YOUR_UNIQUE_REGISTRY_ID",
  "http://www.crateandbarrel.com/Gift-Registry/YOUR_NAMES/YOUR_UNIQUE_REGISTRY_ID",
  "https://www.zola.com/registry/YOUR_REGISTRY_SLUG",
  "http://www.rei.com/GiftRegistryDetails/YOUR_UNIQUE_REGISTRY_ID",
  "https://secure.williams-sonoma.com/registry/YOUR_UNIQUE_REGISTRY_ID/registry-list.html",
])
```

## Example &ndash; Generate HTML Source

The `./example` folder provides a simple example of how how you might
use the `wedding_registry_scraper` gem to generate html for your wedding
website's registry.

It uses [Mustache](http://mustache.github.io/) for templating.
It also relies on [Normalize](https://necolas.github.io/normalize.css/)
and some custom css to make the generated page look reasonable.

```bash
# Go to the example folder and install gem dependencies
cd ./example
bundle

# Execute the example html generator, `registries.rb`, with your
# Zola and Williams-Sonoma registries (use your actual URLs),
bundle exec registries.rb "https://www.zola.com/registry/YOUR_REGISTRY_SLUG" "https://secure.williams-sonoma.com/registry/YOUR_UNIQUE_REGISTRY_ID/registry-list.html" > registries.html

# Open the file
open registries.html
```

## Want to Help?

It should be simple to add another registry by cloning a `Regsitry` inside `lib/wedding_registry_scraper/registries`.

I look forward to your pull-request.

## Like this project and planning on registering?

Why don't you register for Zola using my invite code: https://www.zola.com/invite/pariser

Thanks!
