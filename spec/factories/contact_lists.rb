FactoryBot.define do
  factory :contact_list do
    sequence(:name) { |n| "list#{n}" }
  end
end
