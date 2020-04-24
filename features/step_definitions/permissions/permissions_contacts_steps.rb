When('I go to the contact list') do
  visit '/contacts'
end

Then('I can see the option to edit the contact') do
  profile_h2 = find('h2', text: 'Personal details')
  profile_section = profile_h2.find(:xpath, 'ancestor::div[@class="panel panel--unpadded"]')
  expect(profile_section).to have_selector(:link_or_button, 'Edit')
end

Then('I cannot see the option to edit the contact') do
  profile_h2 = find('h2', text: 'Personal details')
  profile_section = profile_h2.find(:xpath, 'ancestor::div[@class="panel panel--unpadded"]')
  expect(profile_section).not_to have_selector(:link_or_button, 'Edit')
end

Then('I cannot see the option to create a contact') do
  expect(page).to have_content('No matches')
  expect(page).not_to have_selector(:link_or_button, 'Add a person')
end