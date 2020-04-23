Given('an inbound enquiry') do
  visit '/contacts/new'
end

When('I add the enquiry details') do
  fill_in('contact_first_name', with: 'Bob')
  fill_in('contact_last_name', with: 'Jones')
  fill_in('contact_telephone', with: '123456789')
  fill_in('contact_channel', with: 'phone')
  fill_in('contact_enquiry_message', with: 'Bob (94) is Francis Jones brother, and is in need of help')
end

When('I save the enquiry form') do
  click_button('Continue')
end

Then(/^I see a resident created message$/) do
  expect(page.find('.notice')).to have_text('Contact was successfully created.')
end
