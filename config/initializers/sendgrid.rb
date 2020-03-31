SendGridActionMailerAdapter.configure do |config|
    # required
    config.api_key = ENV['SENDGRID_API_KEY']
    
    # optional(SendGrid)
    # config.host = 'host'
    # config.request_headers = { key: 'val' }
    # config.version = 'v3'
    
    # # optional(Retry)
    # config.retry_max_count = 3
    # config.retry_wait_seconds = 3.0
  
    # # optional(Others)
    # config.logger = ::Logger.new(STDOUT)
  end