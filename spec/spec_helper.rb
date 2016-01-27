require 'pqsdk'
require 'webmock/rspec'
require 'support/matchers'
require 'shoulda-matchers'
require 'active_support/core_ext/string'

RSpec.configure do |config|
  config.before do
    PQSDK::Settings.schema = 'http'
    PQSDK::Settings.host = 'www.example.com'
  end

  config.include Shoulda::Matchers::ActiveModel

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.warnings = true

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end
