# Be sure to restart your server when you modify this file.
require 'silencer/logger'

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :authenticity_token, :token, :email]
Rails.application.config.action_mailer.logger = nil

# This will silence all routing logs by replacing Rails::Rack::Logger with silencer on sign_in routes
Rails.application.config.middleware.swap Rails::Rack::Logger, Silencer::Logger, :silence => [%r{^/sign_in}]