# frozen_string_literal: true

need_categories = [
  'phone triage',
  'groceries and cooked meals',
  'physical and mental wellbeing',
  'financial support',
  'staying social',
  'prescription pickups',
  'book drops and entertainment',
  'dog walking',
  'other'
]

FactoryBot.define do
  factory :need do
    contact
    category { need_categories.sample }
    name { Faker::Lorem.sentence }

    trait :completed do
      completed_on { 2.days.ago }
    end

    trait :urgent do
      is_urgent { true }
    end

    factory :need_with_notes do
      transient do
        notes_count { 2 }
      end

      after(:create) do |need, evaluator|
        create_list(:note, evaluator.notes_count, need: need)
      end
    end
  end
end
