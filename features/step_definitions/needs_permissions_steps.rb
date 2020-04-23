Given('I am logged into the system as a(n) {string} user') do |role|
  visit generate_magic_link(role.downcase)
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector(:link_or_button, 'Log out')
end

And('a need is assigned to me') do
  @contact = Contact.create!(first_name: 'Test' + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', user: @user)
end

When('I go to the need list') do
  visit '/'
end

Then('I can see the need in the list') do
  expect(page).to have_content(@contact.first_name)
end

Then('I can not see that need in the list') do
  expect(page).not_to have_content(@contact.first_name)
end

And('a need is assigned to that role') do
  @contact = Contact.create!(first_name: 'Test' + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', role: @role)
end

And('another user exists in that role') do
  @other_user = User.create!(email: 'other_user@email.com', invited: Date.today, roles: [@role])
end

And('a need is assigned to the other user') do
  @contact = Contact.create!(first_name: 'Test' + rand(10**10).to_s(36))
  @need = Need.create!(contact: @contact, name: 'Phone Triage', category: 'Phone Triage', user: @other_user)
end


When('I go to the contact page for that need') do
  visit "/contacts/#{@contact.id}"
end

Then('I should be able to add needs to that contact') do
  expect(page).to have_selector(:link_or_button, 'Triage')
end

Then('I should not be able to add needs to that contact') do
  expect(page).not_to have_selector(:link_or_button, 'Triage')
end