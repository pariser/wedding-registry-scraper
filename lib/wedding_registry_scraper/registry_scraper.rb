class WeddingRegistryScraper::RegistryScraper
  class << self
    def scrape(registry_urls=[], options={})
      all_products = {}

      registry_urls.each do |url|
        unless registry = WeddingRegistryScraper::Registries.initialize_registry(url)
          raise "Could not initialize registry from url #{url.inspect}"
        end

        puts "* Loading items from #{registry.class.name.demodulize}..." if options[:log_messages]
        products = registry.get_items
        puts "  Loaded %d items\n" % products.count if options[:log_messages]

        all_products.merge!(products)
      end

      all_products
    end
  end
end
