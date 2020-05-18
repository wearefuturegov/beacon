When('I go to the contact list') do
  visit '/contacts'
end

Then('I can see the option to edit the contact') do
  expect(page.find('#edit-contact-link')).to be_visible
end

Then('I cannot see the option to edit the contact') do
  expect(page).not_to have_selector('#edit-contact-link')
end

Then('I cannot see the option to create a contact') do
  expect(page).to have_content('No matches')
  expect(page).not_to have_selector(:link_or_button, 'Add a person')
end

And('the contact has sensitive information') do
  @contact.reload
  @contact.update(additional_info: 'This additional information is sensitive')
end

Then('I cannot see that contact\'s sensitive information') do
  expect(@page).not_to have_content('This additional information is sensitive')
end
