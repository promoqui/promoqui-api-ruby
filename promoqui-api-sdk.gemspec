$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "pqsdk/version"

Gem::Specification.new do |s|
  s.name         = 'promoqui-api-sdk'
  s.version      = PQSDK::VERSION
  s.summary      = 'A wrapper around PromoQui HTTP Crawler API'
  s.description  = 'This gem helps Crawler Writers to interact with the PromoQui REST API'
  s.authors      = [ 'Francesco Boffa' ]
  s.email        = 'f.boffa@promoqui.it'
  s.homepage     = ''
  s.license      = 'MIT'
  s.files        = `git ls-files -- lib/*`.split("\n")
  s.require_path = 'lib'

  s.add_dependency 'json'
end

