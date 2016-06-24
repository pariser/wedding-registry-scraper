#!/usr/bin/env ruby

require 'mustache'
require 'wedding_registry_scraper'
require 'pp'

class RegistryNotFoundError < StandardError; end

# A class representing each RegistryItem
#
# registry_item_data is a hash that looks like the following:
# {
#   name: 'Item Title',
#   remaining: 1,
#   desired: 2,
#   url: 'http://www.some-registry.com/items/123456',
#   image_url: 'http://www.some-registry.com/items/123456.jpg',
#   registry_name: 'Some Registry',
#   fulfilled: true,
#   price_type: 'Fixed price',
#   price_value: 90.0,
# }
class RegistryItem < Mustache
  def initialize(sku, registry_item_data)
    @sku = sku
    @data = registry_item_data
  end

  def url
    @data[:url]
  end

  def name
    @data[:name]
  end

  def image_src
    @data[:image_url].sub(%r{^(https?:)?//}, 'http://')
  end

  def fulfillment_description
    if @data[:fulfilled]
      "All fulfilled"
    else
      "#{@data[:remaining]} of #{@data[:desired]} available"
    end
  end

  # Change the price description based on whether this item's "price_type"
  # is FIXED_PRICE or VARIABLE_PRICE (i.e. contribute what you wish)
  # @return [Type] description of returned object
  def price_description
    case @data[:price_type]
    when WeddingRegistryScraper::Registry::FIXED_PRICE
      "$%.2f" % @data[:price_value]
    when WeddingRegistryScraper::Registry::VARIABLE_PRICE
      "Contribute what you wish"
    end
  end
end

class Registry < Mustache
  def initialize(registry_url, options={})
    @registry_url = registry_url

    @registry_scraper = WeddingRegistryScraper::Registries.initialize_registry(registry_url)
    unless @registry_scraper
      raise RegistryNotFoundError, "Could not initialize registry from url #{registry_url.inspect}"
    end

    STDERR.puts "* Loading items from #{registry_name}"

    items = @registry_scraper.get_items
    pp items if options[:verbose]

    @registry_items = items.map do |registry_item_sku, registry_item_data|
      RegistryItem.new(registry_item_sku, registry_item_data)
    end
  end

  def registry_url
    @registry_url
  end

  def registry_name
    @registry_scraper.class.display_name
  end

  def registry_items
    @registry_items
  end
end

# Registries is a Mustache class that renders the `registries.mustache` file
#
class Registries < Mustache
  def initialize(registry_urls, options={})
    @registries = registry_urls.map do |registry_url|
      Registry.new(registry_url, options)
    end
  end

  def registries
    @registries
  end
end

# This file is runnable from the command line, supply one or more URLs to
# scrape as the command line arguments, and redirect output to a file you
# can open in your browser.
#
if $0 == __FILE__
  argv = ARGV.dup
  verobse = true if argv.delete('-v') || argv.delete('--verbose')

  if argv.length == 0
    STDERR.puts <<-USAGE
      Expected to receive one or more registry urls.

      Usage:

        ./registries.rb "http://www.some-registry.com/123456" > registries.html

    USAGE
    exit 1
  end

  options = {}
  options[:verbose] = true if verobse

  puts Registries.new(argv, options).render
end
