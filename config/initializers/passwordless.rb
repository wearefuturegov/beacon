# frozen_string_literal: true

config = Rails.configuration.councils[ENV['COUNCIL'] || :demo]
Passwordless.default_from_address = config[:default_from_address]
Passwordless.restrict_token_reuse = true
Passwordless.expires_at = -> { 1.day.from_now } # How long until a passwordless session expires.
Passwordless.timeout_at = -> { 1.hour.from_now } # How long until a magic link expires.
