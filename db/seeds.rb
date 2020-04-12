# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'factory_bot'
FactoryBot.find_definitions

ActiveRecord::Base.transaction do
  puts "Seeding the database..."

  Faker::Config.locale = 'en-GB'

  FactoryBot.create_list(:user, 5).each do |user|
    contacts = FactoryBot.create_list :contact, 50

    contacts.first(10).each do |contact|
      [1, 2, 3].sample.times do
        FactoryBot.create :need_with_notes,
                          notes_count: [0, 1, 2, 3].sample,
                          contact: contact,
                          user: [user, nil].sample,
                          is_urgent: [true, false].sample,
                          completed_on: [nil, [1,2,3].sample.days.ago].sample
      end
    end
  end

  puts "Finished seeding the database."
end

# make an initial user for sake of the readme
seed_user_emails = ENV['SEED_USER_EMAILS'] || 'admin@example.com'
seed_user_emails.split(',').each do |email|
  User.find_or_initialize_by(email: email.strip)
      .update!(
        admin: true,
        invited: DateTime.now
      )
end
