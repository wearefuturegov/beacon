Given('a resident with a {string} support action') do |support_action|
  @contact = Contact.create!(first_name: 'Test')
  step "I add support actions \"#{support_action}\""
  step 'I submit the add support actions form'
end

Given('a resident with {string} support actions') do |support_actions|
  @contact = Contact.create!(first_name: 'Test')
  support_actions.split(', ').each do |support_action|
    step "I add support actions \"#{support_action}\""
    step 'I submit the add support actions form'
  end
end

When('I add a {string} note {string}') do |category, content|
  visit "/needs/#{@contact.needs.first.id}"
  choose_note_type_from(category)
  @last_note = content
  fill_in('note_body', with: content)
end

And(/^I submit the form to create the note$/) do
  click_button('Add update')
end

Then('the list of notes contains {string}') do |content|
  expect(page).to have_content(content)
end

And('the note category is {string}') do |category|
  expect(page).to have_content(category)
end

And('the last note is at the top') do
  top_entry = page.find('.notes__list > article.note:nth-child(1)')
  expect(top_entry).to have_content(@last_note)
end

def choose_note_type_from(category)
  note_types = { 'Successful Call': 'category_phone_success',
                 'Left Message': 'category_phone_message',
                 'Failed Call': 'category_phone_failure',
                 'Note': 'category_general' }
  radio_id = note_types.fetch(category.to_sym)
  page.find("label[for=#{radio_id}]").click
end
