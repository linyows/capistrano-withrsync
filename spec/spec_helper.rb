require 'tid'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include(Tid)
  config.before(:all) {
    Tid.bundle
    Tid.prepare
  }
  config.after(:all) { Tid.clear }
end
