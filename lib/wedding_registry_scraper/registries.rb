module WeddingRegistryScraper::Registries
  class << self
    def registry_classes
      @registry_classes ||= begin
        self.constants.map do |const|
          obj = self.const_get(const)
          obj if obj.is_a?(Class) && obj < WeddingRegistryScraper::Registry
        end.compact
      end
      @registry_classes
    end

    def registry_class_from_url(url)
      registry_classes.detect do |klass|
        /^https?:\/\/[^\/]*#{klass.domain}/.match(url)
      end
    end

    def initialize_registry(url, options={})
      klass = registry_class_from_url(url)
      klass ? klass.new(url, options) : nil
    end
  end
end

# Load all registries

Dir[File.dirname(__FILE__) + '/registries/*.rb'].each { |file| require file }
