require 'active_support/all'
require_relative 'wedding_registry_scraper/version'

module WeddingRegistryScraper
  autoload :Registry, 'wedding_registry_scraper/registry'
  autoload :Registries, 'wedding_registry_scraper/registries'
  autoload :RegistryScraper, 'wedding_registry_scraper/registry_scraper'

  def self.scrape(*args)
    RegistryScraper.scrape(*args)
  end
end
