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
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    Time::DATE_FORMATS.merge!(default: '%Y/%m/%d %I:%M %p', ymd: '%Y/%m/%d', file: '%Y%m%d%H%M%S')
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Singapore'
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, 'tl']

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
