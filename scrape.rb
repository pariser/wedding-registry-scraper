#!/usr/bin/env ruby

require 'pp'
require 'safe_yaml'
SafeYAML::OPTIONS[:default_mode] = :safe

require './registries'

config = YAML.load_file('config.yml')

global_params = config['global_params'] || {}
global_params.symbolize_keys!

all_products = {}

config['registries'].each do |registry_key, registry_config|
  registry_config.symbolize_keys!

  params = global_params.merge(registry_config)

  registry = Registries.initialize_registry(registry_key, params)
  next unless registry

  puts "* Loading items from #{registry.class.name.demodulize}..."
  products = registry.get_items
  puts "  Loaded %d items" % products.count
  puts ""

  all_products.merge!(products)
end

pp all_products
