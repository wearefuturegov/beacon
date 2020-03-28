# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  FactoryBot.create_list(:organisation, 2).each do |organisation|
    FactoryBot.create_list(:user, 2, organisation: organisation).each do |user|
      contact_list = FactoryBot.create :contact_list

      FactoryBot.create :contact_list_user, contact_list: contact_list, user: user

      contacts = FactoryBot.create_list :contact, 5, contact_list: contact_list

      FactoryBot.create :task, contact: contacts.last, user: user
    end
  end
end
