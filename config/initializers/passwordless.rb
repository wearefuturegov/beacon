config = Rails.configuration.councils[ENV['COUNCIL'] || :demo]
Passwordless.default_from_address =  config[:default_from_address]
# Passwordless.restrict_token_reuse = true
Passwordless.expires_at = lambda { 1.day.from_now } # How long until a passwordless session expires.
expiry_minutes = 30 # ENV['LINK_EXPIRY_MINUTES'] || 10
Passwordless.timeout_at = lambda { expiry_minutes.to_i.minutes.from_now } # How long until a magic link expires.
