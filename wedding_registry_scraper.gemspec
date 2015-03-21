require './lib/wedding_registry_scraper/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'wedding_registry_scraper'
  s.version     = WeddingRegistryScraper::VERSION.to_s

  s.summary     = "A wedding registry scraper"
  s.description = "Look at a bunch of various retailers' wedding registries and consolidate information in one place."

  s.files        = Dir['LICENSE', 'README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.authors     = ["Andrew Pariser"]
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.email       = 'pariser@gmail.com'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/pariser/wedding-registry-scraper'

  s.required_ruby_version = '>= 2.2'

  s.add_runtime_dependency 'unirest', '~> 1.1', '>= 1.1.2'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'activesupport', '~> 4.2'
end
