FactoryBot.define do
  factory :user do
    organisation

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    invited { Faker::Date.backward(days: 10) }
  end
end
