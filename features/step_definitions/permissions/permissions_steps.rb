# Shortcuts for assigned to me, role, team
And('a support action (for a contact )is assigned to me') do
  step 'a support action for contact "Test" is assigned to me'
end

And('a support action (for a contact )is assigned to the other user') do
  step 'a support action for contact "Test" is assigned to the other user'
end

And('a support action (for a contact )is assigned to that role') do
  step 'a support action for contact "Test" is assigned to that role'
end

And('a support action for contact {string} is assigned to role {string}') do |name, role|
  @role = find_role(role)
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36), surname: 'Test', channel: 'Channel')
  @support_action = Need.create!(contact: @contact, name: 'Dog walking', category: 'Dog walking', role: @role)
end

And('a support action for contact {string} is assigned to me') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36), surname: 'Test', channel: 'Channel')
  @support_action = Need.create!(contact: @contact, name: 'Dog walking', category: 'Dog walking', user: @user)
end

And('a support action for contact {string} is assigned to that role') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36), surname: 'Test', channel: 'Channel')
  @support_action = Need.create!(contact: @contact, name: 'Dog walking', category: 'Dog walking', role: @role)
end

And('a support action for contact {string} is assigned to the other user') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36), surname: 'Test', channel: 'Channel')
  @support_action = Need.create!(contact: @contact, name: 'Dog walking', category: 'Dog walking', user: @other_user)
end

When('I go to the contact page for that contact') do
  visit "/contacts/#{@contact.id}"
end

When('I go to the contact page for that support action') do
  visit "/contacts/#{@contact.id}"
end

Then('I can see the contact in the list') do
  expect(page).to have_content(@contact.first_name)
end

Then('I can see the support action in the list') do
  table_content = page.find('tbody').text.downcase
  expect(table_content).to have_content(@support_action.name.downcase)
end

Then('I can not see that support action in the list') do
  content_panel = find('p.no-results')
  expect(content_panel).to have_content 'No matches'
end

Then('I can not see that contact in the list') do
  expect(page).not_to have_content(@contact.first_name)
end

Then('I see a permissions error') do
  find('.alert', text: 'You are not authorized to perform this action.')
end

def find_role(role)
  role = Role.where(name: "#{role} role")
  role.exists? ? role.first : Role.create(name: "#{role} role", role: role)
end
