require 'pqsdk'
require 'webmock/rspec'
require 'support/matchers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.warnings = true

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end