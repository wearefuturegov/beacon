Given('a resident with a {string} support action') do |support_action|
  @contact = Contact.create!(first_name: 'Test')
  step "I add needs \"#{support_action}\""
  step 'I submit the add needs form'
end

Given('a resident with {string} needs') do |support_actions|
  @contact = Contact.create!(first_name: 'Test')
  support_actions.split(', ').each do |support_action|
    step "I add needs \"#{support_action}\""
    step 'I submit the add needs form'
  end
end

Given('I added a {string} note {string}') do |category, content|
  step "I add a '#{category}' note '#{content}'"
  step 'I submit the form to create the note'
end

When('I add a {string} note {string}') do |category, content|
  visit "/needs/#{@contact.needs.first.id}"
  choose_note_type_from(category)
  @last_note = content
  fill_in('note_body', with: content)
end

And(/^I submit the form to create the note$/) do
  click_button('Save update to call')
end

Then('the list of notes contains {string}') do |content|
  expect(page).to have_content(content)
end

And('the note category is {string}') do |category|
  expect(page).to have_content(category)
end

And('the time and date the note was created is present') do
  expect(page).to have_content(@last_note.created_at.strftime('%H:%M on %d %b %Y'))
end

And('the last note is at the top') do
  top_entry = page.find('.notes__list > article.note:nth-child(1)')
  expect(top_entry).to have_content(@last_note)
end

def choose_note_type_from(category)
  select2_note 'note_category', category
end
