# frozen_string_literal: true

FOOD_CATEGORY = 'groceries and cooked meals'

FactoryBot.define do
  factory :need do
    contact
    category { Need.categories.values.sample }
    name { Faker::Lorem.sentence }
    start_on do
      Faker::Date.between(from: 2.days.ago, to: 6.days.from_now) if category.in?(['check in', 'triage', 'mdt review'])
    end

    food_priority do
      category == FOOD_CATEGORY ? [1, 2, nil].sample : nil
    end

    food_service_type do
      category == FOOD_CATEGORY ? ['Hot meal', 'Heat up', 'Grocery delivery', nil].sample : nil
    end

    trait :completed do
      completed_on { 2.days.ago }
    end

    trait :urgent do
      is_urgent { true }
    end

    trait :imported do
      name { 'Imported call log' }
      category { 'triage' }
    end

    factory :need_with_notes do
      transient do
        notes_class { :note }
        notes_count { 2 }
      end

      after(:create) do |need, evaluator|
        create_list(evaluator.notes_class, evaluator.notes_count, need: need)
      end

      factory :imported_need_with_notes do
        imported
        notes_class { :imported_note }
      end
    end
  end
end
