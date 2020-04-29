Given('I chosen to add a new person') do
  visit '/contacts'
  click_link 'Add a person'
end

When('I add the new person details') do
  fill_in('contact_first_name', with: 'Bob')
  fill_in('contact_surname', with: 'Jones')
  fill_in('contact_telephone', with: '123456789')
  fill_in('contact_date_of_birth', with: '01/4/1936')
end

When('I save the person form') do
  click_button('Save')
end

Then(/^I see a resident created message$/) do
  expect(page.find('.notice')).to have_text('Contact was successfully created.')
end
