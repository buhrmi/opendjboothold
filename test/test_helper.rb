ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

Capybara.configure do |config|
  config.default_max_wait_time  = 4 # seconds
end

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:twitter, {
  :provider => 'twitter',
  :uid => '123545',
  :info => {
    :nickname => 'jbloggs',
    :name => 'Joe Bloggs',
    :email => 'jbloggs@gmail.com'
  }
})

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
