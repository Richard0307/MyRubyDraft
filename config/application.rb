require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DraftForSoftwareHut
  class Application < Rails::Application
    config.load_defaults 7.0

    config.active_job.queue_adapter = :delayed_job
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

    # Handle invalid MIME types and URIs
    config.action_dispatch.rescue_responses['ActionDispatch::Http::MimeNegotiation::InvalidType'] = :bad_request
    config.action_dispatch.rescue_responses['Mime::Type::InvalidMimeType'] = :bad_request
    config.action_dispatch.rescue_responses['URI::InvalidURIError'] = :bad_request

    config.time_zone = 'London'

    config.generators do |g|
      g.template_engine      :haml
      g.assets               false
      g.helper               false
      g.jbuilder             false
      g.javascripts          false
      g.stylesheets          false
      g.scaffold_stylesheets false
      g.system_tests         :rspec
      g.integration_tool     :rspec
      g.test_framework       :rspec,
                             request_specs:   false,
                             view_specs:       false,
                             routing_specs:    false,
                             helper_specs:     false,
                             controller_specs: false
    end
  end
end
