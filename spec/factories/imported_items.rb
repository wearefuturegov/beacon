# frozen_string_literal: true

FactoryBot.define do
  factory :imported_item do
    name { Faker::Lorem.sentence }

    factory :imported_item_with_contact do
      transient do
        contacts_class { :contact }
        contacts_count { 2 }
      end

      after(:create) do |imported_item, evaluator|
        create_list(evaluator.contacts_class, evaluator.contacts_count, imported_item: imported_item)
      end
    end
  end
end
