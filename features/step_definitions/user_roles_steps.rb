Then('I see the option to view the list of users') do
  main_menu = find('.main-menu')
  expect(main_menu).to have_selector(:link_or_button, 'Users')
end

And('I am viewing the users list') do
  find('.main-menu__link', text: 'Users').click
end

When('I select a user') do
  page.find('.selectable > td:nth-child(7) > a').click
end

And('another role {string} exists') do |role|
  Role.create(name: role, role: role)
end

Then('I can see the edit users page') do
  expect(page).to have_content("Edit #{@user.email}")
end

And('I am editing my user profile') do
  visit("/users/#{@user.id}/edit")
end

And('I select that I am in the {string} role') do |role|
  find('label', text: role).click
end

When('I save my changes') do
  find('button[type=submit]').click
end

Then('I see that my roles have been updated') do
  user_row = first('tr.selectable')
  expect(user_row).to have_content('other role')
  expect(user_row).to have_content('manager role')
end

And('I see the option to switch between my roles') do
  role_switcher = find('form.role-switcher')
  expect(role_switcher).to have_select('id', options: ['other role', 'manager role'])
end

Then(/^I can see the support action filters$/) do
  main_menu = find('.main-menu')
  expect(main_menu).to have_selector(:link_or_button, 'All triages and check-ins')
end

Then(/^I can not see the support action filters$/) do
  main_menu = find('.main-menu')
  expect(main_menu).not_to have_selector(:link_or_button, 'All triages and check-ins')
end

Then(/^I can see the team action filters$/) do
  main_menu = find('.main-menu')
  expect(main_menu).to have_selector(:link_or_button, 'Team referrals')
  expect(main_menu).to have_selector(:link_or_button, 'Team to do')
  expect(main_menu).to have_selector(:link_or_button, 'Team in progress')
  expect(main_menu).to have_selector(:link_or_button, 'Team completed')
end

Then(/^I can not see the team action filters$/) do
  main_menu = find('.main-menu')
  expect(main_menu).not_to have_selector(:link_or_button, 'Team referrals')
  expect(main_menu).not_to have_selector(:link_or_button, 'Team to do')
  expect(main_menu).not_to have_selector(:link_or_button, 'Team in progress')
  expect(main_menu).not_to have_selector(:link_or_button, 'Team completed')
end
