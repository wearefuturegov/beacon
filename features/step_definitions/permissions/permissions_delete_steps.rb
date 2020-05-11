Given('no notes exists on the support actions') do
  # nothing to do here
end

When('I edit the support action') do
  visit "/needs/#{@contact.needs.first.id}"
end

Then('I can delete the support action') do
  delete_btn = page.find("#delete-need-#{@contact.needs.first.id}")
  expect(delete_btn).to be_visible
  delete_btn.click
  page.accept_alert
end

Then('I can see a deletion confirmation message') do
  page.find('.notice', text: "'Dog walking' was successfully deleted.")
end

Then('I cannot delete the support action') do
  expect(page.should have_no_selector("#delete-need-#{@contact.needs.first.id}"))
end

Given('someone else added a {string} note {string}') do |category, content|
  step 'Someone else is logged into the system'

  Capybara.using_session('Second_users_session') do
    visit "/needs/#{@contact.needs.first.id}"
    step "I add a '#{category}' note '#{content}'"
    step 'I submit the form to create the note'
    step 'I log out'
  end

  # check the notes by somebody else exists
  visit "/needs/#{@contact.needs.first.id}"
  top_entry = page.find('.notes__list > article.note:nth-child(1)')
  expect(top_entry).to have_content(content)
end
