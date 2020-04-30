namespace :upgrade do
  namespace :v2_0_0 do
    desc 'Create roles in the database'
    task create_roles: :environment do
      {
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
      }.map { |name, role| Role.create(name: name, role: role) unless Role.exists?(name: name, role: role) }
    end

    desc 'Assign role to user based on admin field'
    task assign_roles: :environment do
      admin_role = Role.find_by!(role: 'manager')
      agent_role = Role.find_by!(role: 'agent')
      User.all.find_each do |user|
        user.roles << (user.admin? ? admin_role : agent_role)
        user.roles = user.roles.uniq
        user.save!
      end
    end
  end
end
