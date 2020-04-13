# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    need
    user
    body { Faker::Lorem.sentence }
    category { Note.categories.values.sample }
  end
end
