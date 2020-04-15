Given(/^a resident$/) do
  @contact = Contact.create!(first_name: 'Test')
end

Given(/^I am on a call with a resident$/) do
  @contact = Contact.create!(first_name: 'Test')
end

Given(/^I am editing the residents profile$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
end

When('I edit the special delivery details {string}') do |details|
  fill_in('contact_delivery_details', with: details)
end

When('I edit the dietary details to {string}') do |details|
  fill_in('contact_dietary_details', with: details)
end

When('I edit the total number of people to {string}') do |count|
  fill_in('contact_count_people_in_house', with: count)
end

When(/^I edit the residents name$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_first_name', with: 'TestFirstName')
  fill_in('contact_middle_names', with: 'TestMiddle Names')
  fill_in('contact_surname', with: 'TestSurname')
end

When(/^I edit the residents address$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_address', with: 'Test Address')
  fill_in('contact_postcode', with: 'TE5 7PC')
end

When(/^I edit the residents contact details$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_email', with: 'test@test.com')
  fill_in('contact_telephone', with: '01 811 8055')
  fill_in('contact_mobile', with: '0770 123 456')
end

When(/^I edit the residents vulnerability status$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  find('label[for=is_vulnerable_true]').click
end

When(/^I edit the residents covid-19 status$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  find('label[for=has_covid_symptoms_true]').click
end

When('I choose {string} for any children under 15') do |option|
  if option == 'Yes'
    choose 'any_children_below_15_true'
  else
    choose 'any_children_below_15_false'
  end
end

When('I choose {string} to eligible for free prescriptions') do |option|
  if option == 'Yes'
    choose 'eligible_for_free_prescriptions_true'
  else
    choose 'eligible_for_free_prescriptions_false'
  end
end

When('I choose {string} to any dietary requirements') do |option|
  if option == 'Yes'
    choose 'any_dietary_requirements_true'
  else
    choose 'any_dietary_requirements_false'
  end
end

When(/^I edit the residents additional info$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_additional_info', with: 'Test additional info')
end

When(/^I save the edit resident form$/) do
  click_button('Save changes')
end

Then('the residents list of needs contains {string}') do |need|
  visit "/contacts/#{@contact.id}"
  expect(page).to have_content(need)
end

Then(/^I see a resident updated message$/) do
  expect(page).to have_content('Contact was successfully updated.')
end

Then('the special delivery details are {string}') do |details|
  expect(page).to have_content(details)
end

Then('the dietary details is {string}') do |details|
  expect(page).to have_content(details)
end

Then('the children under 15 details are {string}') do |details|
  expect(page).to have_content("Children under 15: #{details}")
end

Then('eligible for free prescriptions is {string}') do |details|
  expect(page).to have_content("Free prescriptions? #{details}")
end

Then('the dietary requirements is {string}') do |details|
  expect(page).to have_content("Any dietary requirements? #{details}")
end

Then('the total number of people is {string}') do |count|
  # TODO: add test ids
  expect(page).to have_content(count)
end

Then(/^the residents names have been updated$/) do
  expect(page).to have_content('TestFirstName')
  # expect(page).to have_content('TestMiddle Names')
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

Then(/^the residents covid-19 status has been updated$/) do
  expect(page.find('#contact-has-covid').text).to eq('Yes')
end
