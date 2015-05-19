require 'simplecov'
SimpleCov.start

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

RSpec.configure do |config|
  config.order = 'random'
  config.raise_errors_for_deprecations!

  config.before :each do
    DatabaseCleaner.start
  end
  config.after(:each) do
    Redis.new.flushall
    DatabaseCleaner.clean
  end
end
