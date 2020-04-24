Given('I am logged into the system as a(n) {string} user') do |role|
  visit generate_magic_link(role.downcase)
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector(:link_or_button, 'Log out')
end

# Shortcuts for assigned to me, role, team
And('a need (for a contact )is assigned to me') do
  step 'a need for contact "Test" is assigned to me'
end

And('a need (for a contact )is assigned to the other user') do
  step 'a need for contact "Test" is assigned to the other user'
end

And('a need (for a contact )is assigned to that role') do
  step 'a need for contact "Test" is assigned to that role'
end

And('a need for contact {string} is assigned to me') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', user: @user)
end

And('a need for contact {string} is assigned to that role') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', role: @role)
end

And('a need for contact {string} is assigned to the other user') do |name|
  @contact = Contact.create!(first_name: name + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', user: @other_user)
end

When('I go to the contact page for that need/contact') do
  visit "/contacts/#{@contact.id}"
end

Then('I can see the contact/need in the list') do
  expect(page).to have_content(@contact.first_name)
end

Then('I can not see that contact/need in the list') do
  expect(page).not_to have_content(@contact.first_name)
end

Then('I see a permissions error') do
  find('.alert', text: 'You are not authorized to perform this action.')
end
