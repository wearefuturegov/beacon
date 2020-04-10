# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    need
    user
    body { Faker::Lorem.sentence }
    category { %w[note phone_success phone_message phone_failure].sample }
  end
end
