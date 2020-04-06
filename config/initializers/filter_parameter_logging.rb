# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :authenticity_token, :token, :email]
