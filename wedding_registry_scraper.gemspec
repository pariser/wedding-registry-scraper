Gem::Specification.new do |s|
  s.name        = 'wedding_registry_scraper'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "A wedding registry scraper"
  s.description = "Look at a bunch of various retailers' wedding registries and consolidate information in one place."
  s.authors     = ["Andrew Pariser"]
  s.email       = 'pariser@gmail.com'
  s.files       = ["lib/wedding_registry_scraper.rb"]
  s.homepage    =
    'https://github.com/pariser/wedding-registry-scraper'
  s.license       = 'MIT'

  s.add_runtime_dependency 'unirest', '~> 1.1', '>= 1.1.2'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'activesupport', '~> 4.2'
end
