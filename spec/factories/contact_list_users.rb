# frozen_string_literal: true

FactoryBot.define do
  factory :contact_list_user do
    contact_list
    user
  end
end
