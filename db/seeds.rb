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

  roles = {
    'Contact Centre Manager' => 'manager',
    'Contact Centre Agent' => 'agent',
    'MDT' => 'mdt',
    'Food Hub' => 'food_delivery_manager',
    'Adult Social Care' => 'council_service_adult_social_care',
    "Children's Social Care" => 'council_service_child_social_care',
    'Housing' => 'council_service_housing',
    'Early Help' => 'council_service_early_help',
    'Welfare Rights' => 'council_service_welfare_rights',
    'Public Health' => 'council_service_public_health',
    'Mental Health Specialist (anxiety and bereavement)' => 'council_service_mental_health',
    'Employment Team' => 'council_service_employment',
    'Camden VCS Team' => 'council_service_vcs',
    'Neighbourhood VCS Huddle' => 'council_service_neighbourhood_vcs',
    'Simple Needs Team' => 'council_service_simple_needs',
    'Social Prescribing' => 'council_service_social_prescribing'
  }.map do |name, role|
    created_role = Role.create(name: name, role: role)
    [role, created_role]
  end.to_h

  if ENV['COUNCIL'] == 'camden'
    FactoryBot.create_list(:user, 5).each do |user|
      user.roles = [roles[%w[manager agent].sample]]
      user.save

      contacts = FactoryBot.create_list :contact, 50

      contacts.each do |contact|
        FactoryBot.create :imported_need_with_notes,
                          notes_count: 1,
                          contact: contact
      end
    end
  else
    FactoryBot.create_list(:user, 5).each do |user|
      user.roles = [roles[%w[manager agent].sample]]
      user.save

      contacts = FactoryBot.create_list :contact, 50

      contacts.first(10).each do |contact|
        [1, 2, 3].sample.times do
          FactoryBot.create :need_with_notes,
                            notes_count: [0, 1, 2, 3].sample,
                            contact: contact,
                            user: [user, nil].sample,
                            is_urgent: [true, false].sample,
                            status: Need.statuses.map { |_k,v| v }.sample
        end
      end
    end
  end

  puts "Finished seeding the database."
end

# make an initial user for sake of the readme
seed_user_emails = ENV['SEED_USER_EMAILS'] || 'admin@example.com'
seed_user_emails.split(',').each do |email|
  admin_role = Role.find_by(role: 'manager')
  User.find_or_initialize_by(email: email.strip)
      .update!(
        admin: true,
        invited: DateTime.now,
        roles: [admin_role],
        role: admin_role
      )
end
