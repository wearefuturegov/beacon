FactoryBot.define do
  factory :note do
    task
    user
    body { Faker::Lorem.sentence }
  end
end
