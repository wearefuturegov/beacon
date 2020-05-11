Given('no notes exists on the support actions') do
  # nothing to do here
end

When('I edit the support action') do
  visit "/needs/#{@contact.needs.first.id}"
end

Then('I can delete the support action') do
  @deleted_support_action = @contact.needs.first.id
  delete_btn = page.find("#delete-need-#{@deleted_support_action}")
  expect(delete_btn).to be_visible
  delete_btn.click
  page.accept_alert
end

Then('I can see a deletion confirmation message') do
  page.find('.notice', text: "'Dog walking' was successfully deleted.")
end

Then('I cannot delete the support action') do
  expect(page.should(have_no_selector("#delete-need-#{@contact.needs.first.id}")))
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

Given('I have deleted a support action') do
  step "they have logged into the system as a 'food_delivery_manager' user"
  step "a support action for contact 'Freddie Stone' is assigned to role 'manager'"
  step 'they have logged out'
  step "I am logged into the system as a 'manager' user"
  step 'I edit the support action'
  step 'I can delete the support action'
end

When('I choose to restore the support action') do
  visit '/deleted_needs?order=deleted_at&order_dir=DESC'
  page.find("#restore-need-#{@deleted_support_action}").click
  page.accept_alert
end

Then('I can see the restored support action details') do
  page.find('.notice', text: 'Restored')
  visit "/needs/#{@deleted_support_action}"
  need_title = page.find("#need-#{@deleted_support_action}-title")
  expect(need_title).to be_visible
end

Then('I can delete the note') do
  @last_note_parent = @contact.needs.first.id
  top_entry = page.find('.notes__list > article.note:nth-child(1)')
  expect(top_entry).to have_content(@last_note)
  delete_btn = page.find('.note-delete-link')
  expect(delete_btn).to be_visible
  delete_btn.click
  page.accept_alert
end

Given('I have deleted a note') do
  step "I am logged into the system as a 'manager' user"
  step "a resident with 'Dog walking' support actions"
  step "I added a 'Note' note 'to be restored'"
  step 'I edit the support action'
  step 'I can delete the note'
end

When('I choose to restore the note') do
  visit '/deleted_notes?order=deleted_at&order_dir=DESC'
  top_entry = page.find('table > tbody > tr:nth-child(1) > td:nth-child(2)')
  expect(top_entry).to have_content(@last_note)

  top_entry_btn = page.find('table > tbody > tr:nth-child(1) > td:nth-child(4) > a')
  expect(top_entry_btn).to have_content('Restore')

  top_entry_btn.click
  page.accept_alert
end

Then('I can see the restored note details') do
  page.find('.notice', text: 'Restored')
  visit "/needs/#{@last_note_parent}"
  need_title = page.find("#need-#{@last_note_parent}-title")
  expect(need_title).to be_visible
  step 'the last note is at the top'
end
