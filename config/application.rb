require_relative 'boot'

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
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rubygem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    if Rails.env.development? #for rails-erd gem to generate a diagram
      def eager_load!
        Zeitwerk::Loader.eager_load_all
      end
    end


    config.to_prepare do
      ActionText::ContentHelper.allowed_tags << "iframe" #youtube embed

      #video previews for action_text
      ActionText::ContentHelper.allowed_attributes.add 'style'
      ActionText::ContentHelper.allowed_attributes.add 'controls'
      ActionText::ContentHelper.allowed_tags.add 'audio'
      ActionText::ContentHelper.allowed_tags.add 'video'
      ActionText::ContentHelper.allowed_tags.add 'source'
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
