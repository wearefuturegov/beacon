Given('a user exists with the email {string}') do |email|
  User.create!(first_name: 'John',
               last_name: 'Doe',
               email: email,
               invited: Date.today)
end

Given('a users email address {string}') do |email|
  @user_email = email
end

When(/^I enter the email address into the user form$/) do
  visit '/'
  click_link 'Users'
  click_link 'Invite a user'
  fill_in('user_email', with: @user_email)
end

And(/^I select that the user is an admin$/) do
  find('label[for=user_admin_true]').click
end

When(/^I send the invite$/) do
  click_button 'Send invite'
end

Then(/^I see a user created message$/) do
  expect(page.find('.notice')).to have_content('User was successfully created.')
end

Then(/^I see an error message about the email$/) do
  find('body').has_content? 'Email has already been taken.'
end

And(/^the email address is in the list of users$/) do
  find('body').has_content? @user_email
end

Then(/^I cannot access the user form$/) do
  expect(page).not_to have_link('Users')
end

When('I search for the user by {string}') do |query|
  visit 'users'
  fill_in('search', with: query)
  find('.search').native.send_keys('return')
end

Then(/^I see the user in the search results$/) do
  results_table = page.find('.table')
  expect(results_table).to have_text('John Doe')
  expect(results_table).to have_text('user1@test.com')
end
