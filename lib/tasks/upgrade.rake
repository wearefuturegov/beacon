namespace :upgrade do
  namespace :v1_1_0 do
    task all: [
      :update_contacts_channel,
      :update_needs_statuses,
      :create_roles,
      :assign_roles
    ]
  end

  task v1_1_0: 'v1_1_0:all'
end
