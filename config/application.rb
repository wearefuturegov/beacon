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

    ActiveRecord::SessionStore::Session.table_name = 'session_table'
    ActiveRecord::SessionStore::Session.primary_key = 'session_id'
    ActiveRecord::SessionStore::Session.data_column_name = 'data'
    ActiveRecord::SessionStore::Session.serializer = :json

    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag.html_safe }
  end
end
