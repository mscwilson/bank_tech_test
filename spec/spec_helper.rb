# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "statement"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end

DEFAULT_TRANSACTION_AMOUNT = 100
STATEMENT_HEADER = Statement::HEADER
DEFAULT_TRANSACTION_STR = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
DEFAULT_STATEMENT = "#{STATEMENT_HEADER}\n#{DEFAULT_TRANSACTION_STR}\n"
