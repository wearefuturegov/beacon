require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IHaveINeed
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # access like:
    # <%= Rails.configuration.councils[ENV['COUNCIL']]['support_email'] %>
    config.councils = config_for(:councils)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag.html_safe }

    config.log_tags = [
        :request_id,
        ->(req) {
          session_key = (Rails.application.config.session_options || {})[:key]
          session_data = req.cookie_jar.encrypted[session_key] || {}
          user_id = session_data["email"] || "guest"
          "user: #{user_id.to_s}"
        }
    ]
  end
end
