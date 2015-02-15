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

I intend to get this working with:

* Crate &amp; Barrel
* Williams Sonoma
* Sur la Table
* Pottery Barn

## Usage

Copy `config.yml.example` to `config.yml`

Edit this file to include your registries and your authentication creditials.

Run `./scrape.rb`

## Want to Help?

There are two types of registries, `PrivateRegistry` (requires authentication) and `PublicRegistry`, with respective examples `Registries::Zola` and `Registries::HeathCeramics`.

It should be simple to add another registry by cloning the current pattern.

## Like this project and planning on registering?

Why don't you register for Zola using my invite code: https://www.zola.com/invite/pariser

Thanks!
