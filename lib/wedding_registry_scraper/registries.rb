#!/usr/bin/env ruby

require 'active_support/core_ext/string'
require 'wedding_registry_scraper/registry'

module WeddingRegistryScraper::Registries
  class << self
    def get_registry_class(registry)
      class_name = "WeddingRegistryScraper::Registries::#{registry.to_s.classify}"
      klass = class_name.constantize
    rescue => e
      puts e
      STDERR.puts "Registry #{registry.inspect} not found (could not find class #{class_name.inspect})"
    else
      klass
    end

    def initialize_registry(registry, params={})
      url = params.delete("url") || params.delete(:url)
      klass = get_registry_class(registry)
      klass ? klass.new(url, params) : nil
    end
  end
end

# Load all registries

Dir[File.dirname(__FILE__) + '/registries/*.rb'].each { |file| require file }
