Given(/^a resident$/) do
  @contact = Contact.create!(first_name: 'Test')
end

When(/^I edit the residents name$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit profile'
  fill_in('contact_first_name', with: 'TestFirstName')
  fill_in('contact_middle_names', with: 'TestMiddle Names')
  fill_in('contact_surname', with: 'TestSurname')
end

When(/^I edit the residents address$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit profile'
  fill_in('contact_address', with: 'Test Address')
  fill_in('contact_postcode', with: 'TE5 7PC')
end

When(/^I edit the residents contact details$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit profile'
  fill_in('contact_email', with: 'test@test.com')
  fill_in('contact_telephone', with: '01 811 8055')
  fill_in('contact_mobile', with: '0770 123 456')
end

When(/^I edit the residents vulnerability status$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit profile'
  choose 'is_vulnerable_true'
end

When(/^I edit the residents additional info$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit profile'
  fill_in('contact_additional_info', with: 'Test additional info')
end

When(/^I save the edit resident form$/) do
  click_button('Save changes')
end

Then('the residents list of needs contains {string}') do |need|
  expect(page).to have_content(need)
end

Then(/^I see a resident updated message$/) do
  expect(page).to have_content('Contact was successfully updated.')
end

Then(/^the residents names have been updated$/) do
  expect(page).to have_content("TestFirstName's Needs")
  expect(page).to have_content('TestMiddle Names')
  expect(page).to have_content('TestSurname')
end

Then(/^the residents address has been updated$/) do
  expect(page).to have_content('Test Address')
  expect(page).to have_content('TE5 7PC')
end

Then(/^the residents contact details have been updated$/) do
  expect(page).to have_content('test@test.com')
  expect(page).to have_content('01 811 8055')
  expect(page).to have_content('0770 123 456')
end

Then(/^the residents vulnerability status has been updated$/) do
  expect(page).to have_content('This is a vulnerable person')
end

Then(/^the residents additional info has been updated$/) do
  expect(page).to have_content('Test additional info')
end
