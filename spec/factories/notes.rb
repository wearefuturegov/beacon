FactoryBot.define do
  factory :note do
    task
    body { Faker::Lorem.sentence }
  end
end
