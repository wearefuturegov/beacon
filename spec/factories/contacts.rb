FactoryBot.define do
  priorities = ['low', 'medium', 'high']

  factory :contact do
    first_name { Faker::Name.first_name }
    middle_names { Faker::Name.middle_name }
    surname { Faker::Name.last_name }
    address { Faker::Address.full_address }
    postcode { Faker::Address.postcode }
    telephone { Faker::PhoneNumber.phone_number }
    mobile { Faker::PhoneNumber.cell_phone }
    is_vulnerable { true }
    priority { priorities.sample }

    priorities.each do |priority|
      trait "#{priority}_priority" do
        priority { priority }
      end
    end
  end
end
