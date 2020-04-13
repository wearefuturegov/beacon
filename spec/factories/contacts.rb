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
    shielded_id { Faker::Number.between(from: 1, to: 9000) }
    nhs_number { Faker::Number.between(from: 100_000, to: 800_000) }
    gp_practice_code { Faker::Alphanumeric.alpha(number: 6) }
    mosaid_id { Faker::Number.leading_zero_number(digits: 10) }
    mosaid_id2 { Faker::Number.leading_zero_number(digits: 10) }
    eh_flag { Faker::Boolean.boolean(true_ratio: 0.3) }
    eh_team { Faker::Company.name }
    eh_worker { Faker::Name.name }
    cssw_flag { Faker::Boolean.boolean(true_ratio: 0.2) }
    cssw_team { Faker::Company.name }
    cssw_worker { Faker::Name.name }
    asc_flag { Faker::Boolean.boolean(true_ratio: 0.2) }
    asc_psr { Faker::Company.name }
    asc_workers { Faker::Name.name }
  end
end
