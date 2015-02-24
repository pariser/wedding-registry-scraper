#!/usr/bin/env ruby

require 'colored'
require './registry'
require 'active_support/core_ext/string'

module Registries
  class << self
    def get_registry_class(registry)
      class_name = "Registries::#{registry.classify}"
      klass = class_name.constantize
    rescue
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
