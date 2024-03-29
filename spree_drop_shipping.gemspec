# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_drop_shipping'
  s.version     = '3.0.6.1'
  s.summary     = 'Drop Shipping Extension'
  s.description = 'Drop Shipping Extension'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Julián Ortiz'
  s.email     = 'julian.ortiz@web-experto.com.ar'
  s.homepage  = 'https://www.web-experto.com.ar'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 3.0.0', '< 4.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_backend', spree_version

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'mysql2', '~> 0.4.5'
  s.add_development_dependency 'sqlite3', '~> 1.3.13'
  s.add_development_dependency 'roo'
end
