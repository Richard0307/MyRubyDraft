# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
# Allows us to call FactoryBot methods without doing FactoryBot._
  config.include FactoryBot::Syntax::Methods
  # Let's us use the capybara stuf in our specs
  config.include Capybara::DSL
  # Let's us do login_as(user)
  config.include Warden::Test::Helpers
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Ensure our database is definitely empty before running the suite
  # (e.g. if a process got killed and things weren't cleaned up)
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transactions for non-javascript tests as it is much faster than truncation
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    ActionMailer::Base.deliveries.clear
  end

  # Can't use transaction strategy with Javascript tests because they are run in
  # a separate thread which does not have access to data in an uncommitted transaction.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  # Help debug tests
  config.after(:each, screenshot_on_failure: true) do |example|
    if example.exception
      save_and_open_screenshot
    end
  end

  # Use this to test real error pages (e.g. epiSupport)
  config.around(:each, error_page: true) do |example|
    # Rails caches the action_dispatch setting. Need to remove it for the new setting to apply.
    Rails.application.remove_instance_variable(:@app_env_config) if Rails.application.instance_variable_defined?(:@app_env_config)
    Rails.application.config.action_dispatch.show_exceptions = true
    Rails.application.config.consider_all_requests_local = false

    example.run

    Rails.application.remove_instance_variable(:@app_env_config) if Rails.application.instance_variable_defined?(:@app_env_config)
    Rails.application.config.action_dispatch.show_exceptions = false
    Rails.application.config.consider_all_requests_local = true
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.file_fixture_path = Rails.root.join('spec', 'factories', 'files')
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.match  = :prefer_exact
end

Capybara.automatic_label_click = true

def sleep_for_js(sleep_time: 0.5)
  sleep sleep_time
end
