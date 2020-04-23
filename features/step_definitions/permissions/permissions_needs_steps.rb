When('I go to the need list') do
  visit '/'
end

And('another user exists in that role') do
  @other_user = User.create!(email: 'other_user@email.com', invited: Date.today, roles: [@role])
end

Then('I should be able to add needs to that contact') do
  expect(page).to have_selector(:link_or_button, 'Triage')
end

Then('I should not be able to add needs to that contact') do
  expect(page).not_to have_selector(:link_or_button, 'Triage')
end