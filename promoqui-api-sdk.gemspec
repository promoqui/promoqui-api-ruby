$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'pqsdk/version'

Gem::Specification.new do |s|
  s.name         = 'promoqui-api-sdk'
  s.version      = PQSDK::VERSION
  s.summary      = 'A wrapper around PromoQui HTTP Crawler API'
  s.description  = 'This gem helps Crawler Writers to interact with the PromoQui REST API'
  s.authors      = ['Francesco Boffa']
  s.email        = 'f.boffa@promoqui.it'
  s.homepage     = 'https://github.com/promoqui/promoqui-api-ruby'
  s.license      = 'MIT'
  s.files        = `git ls-files -- lib/*`.split("\n")
  s.require_path = 'lib'

  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'faraday', '~> 0.9.2'
  s.add_dependency 'activemodel', '~> 4.1', '>= 4.1.0'
  s.add_dependency 'activesupport', '~> 4.1', '>= 4.1.0'

  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  s.add_development_dependency 'rake', '~> 10.5', '>= 10.5.0'
  s.add_development_dependency 'guard', '~> 2.13', '>= 2.13.0'
  s.add_development_dependency 'guard-rspec', '~> 4.6', '>= 4.6.0'
  s.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.6'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1', '>= 3.1.0'
end
