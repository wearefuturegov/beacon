FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    middle_names { Faker::Name.middle_name }
    surname { Faker::Name.last_name }
    address { Faker::Address.full_address }
    postcode { Faker::Address.postcode }
    telephone { Faker::PhoneNumber.phone_number }
    mobile { Faker::PhoneNumber.cell_phone }
    is_vulnerable { true }
    priority { 'medium' }
  end
end
