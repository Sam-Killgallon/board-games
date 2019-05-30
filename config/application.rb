# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BoardGames
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    config.action_mailer.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: 587,
      domain: 'pendium.killgallon.tech',
      authentication: :plain,
      user_name: 'apikey',
      password: Rails.application.credentials.dig(:sendgrid, :api_key)
    }
  end
end
