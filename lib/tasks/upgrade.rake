namespace :upgrade do
  namespace :v2_0_0 do
    task all: [
      :update_contacts_channel,
      :update_needs_statuses,
      :create_roles,
      :assign_roles
    ]
  end

  task v2_0_0: 'v2_0_0:all'
end
