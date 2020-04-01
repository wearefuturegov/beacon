FactoryBot.define do
  factory :note do
    need
    user
    body { Faker::Lorem.sentence }
  end
end
