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

## Usage

Add to your Gemfile

    gem 'wedding-registry-scraper'

Use `WeddingRegistryScraper#scrape`:

    require 'wedding_registry_scraper'

    WeddingRegistryScraper.scrape({
      :heath_ceramics   => "http://www.heathceramics.com/giftregistry/view/index/id/YOUR_UNIQUE_REGISTRY_ID",
      :crate_and_barrel => "http://www.crateandbarrel.com/Gift-Registry/YOUR_NAMES/YOUR_UNIQUE_REGISTRY_ID",
      :zola             => "https://www.zola.com/registry/YOUR_REGISTRY_SLUG",
      :rei              => "http://www.rei.com/GiftRegistryDetails/YOUR_UNIQUE_REGISTRY_ID",
      :williams_sonoma  => "https://secure.williams-sonoma.com/registry/YOUR_UNIQUE_REGISTRY_ID/registry-list.html",
    })


## Want to Help?

It should be simple to add another registry by cloning a `Regsitry` inside `lib/wedding_registry_scraper/registries`.

## Like this project and planning on registering?

Why don't you register for Zola using my invite code: https://www.zola.com/invite/pariser

Thanks!
