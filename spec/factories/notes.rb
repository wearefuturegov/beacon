# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    need
    user
    category { Note.categories.values.sample }
    body { Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 3) }
  end
end
