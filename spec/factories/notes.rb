# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    need
    user
    body { Faker::Lorem.sentence }
    category { Faker::Lorem.words(number:1) }
  end
end
