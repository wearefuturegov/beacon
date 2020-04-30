namespace :upgrade do
  namespace :v1_2 do
    task all: [
      :update_contacts_channel,
      :update_needs_statuses,
      :create_roles,
      :assign_roles
    ]
  end

  task v1_2: 'v1_2:all'
end
