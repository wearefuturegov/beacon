FactoryBot.define do
  factory :task do
    contact
    user

    name { Faker::Lorem.sentence }
    due_by { 2.days.from_now }

    trait :completed do
      due_by { 3.days.ago }
      completed_on { 2.days.ago }
    end
  end
end
