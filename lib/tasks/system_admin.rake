namespace :upgrade do
  namespace :v3_0_0 do
    desc 'Create System admin role'
    task create_sysadmin: :environment do
      ActiveRecord::Base.transaction do
        {
          'System Admin' => 'sysadmin'
        }.map { |name, role| Role.create(name: name, role: role) unless Role.exists?(name: name, role: role) }
      end
    end
  end
end
