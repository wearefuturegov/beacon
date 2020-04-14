# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    middle_names { Faker::Name.middle_name }
    surname { Faker::Name.last_name }
    address { Faker::Address.full_address }
    postcode { Faker::Address.postcode }
    telephone { Faker::PhoneNumber.phone_number }
    mobile { Faker::PhoneNumber.cell_phone }
    is_vulnerable { Faker::Boolean.boolean(true_ratio: 0.3) }
    additional_info {}
    count_people_in_house { Faker::Number.between(from: 0, to: 6) }
    any_children_below_15 { Faker::Boolean.boolean(true_ratio: 0.2) }
    delivery_details { Faker::Lorem.sentence }
    any_dietary_requirements { Faker::Boolean.boolean(true_ratio: 0.2) }
    dietary_details { Faker::Lorem.sentence }
    cooking_facilities { Faker::Lorem.sentence }
    eligible_for_free_prescriptions { Faker::Boolean.boolean(true_ratio: 0.2) }
    date_of_birth { Faker::Date.between(from: 93.years.ago, to: 15.years.ago) }
    # extra nhs info
    mosaic_id { Faker::Number.leading_zero_number(digits: 10) }
    known_to_asc? { ['1', ''].sample }
    linked_phones { [nil, 'ASC_HomePhone:- 0207 226 3450 CTAX_MobilePhone:- 07546 21760 HOUSING_HomePhone:- 020 7439 0980 '].sample }
  end
end
