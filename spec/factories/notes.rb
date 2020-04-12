# frozen_string_literal: true

note_categories = [
  'note',
  'phone_success',
  'phone_message',
  'phone_failure'
]

FactoryBot.define do
  factory :note do
    need
    user
    category { note_categories.sample }
    body { Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 3) }
  end
end
