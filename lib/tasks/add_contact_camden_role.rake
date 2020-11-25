namespace :update do
  desc 'Create Contact Camden role in the database'
  task create_contact_camden_role: :environment do
    ActiveRecord::Base.transaction do
      {
        'Contact Camden' => 'council_service_contact'
      }.map { |name, role| Role.create(name: name, role: role) unless Role.exists?(name: name, role: role) }
    end
  end
end
