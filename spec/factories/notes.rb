# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    need
    user
    body { Faker::Lorem.sentence }
  end
end
