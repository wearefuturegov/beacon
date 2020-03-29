FactoryBot.define do
  factory :note do
    contact
    body { Faker::Lorem.sentence }
  end
end
