Given('an assessment is assigned to me') do
  @contact = Contact.create!(first_name: 'Test')
  @need = Need.create!(contact: @contact, name: 'Triage', category: 'triage', status: 'to_do', user: @user, start_on: DateTime.now - 1.days)
end

Given('I am on the failed assessment page') do
  visit "/assessments/#{@need.id}/fail"
end

And('I fail the assessment because {string}') do |reason|
  find('label', text: reason).click
  find('label', text: 'Yes').click if reason == 'The call was not answered'

  @random_note = rand(10**10).to_s(36)
  find('#assessment_failure_form_note_description').fill_in(with: @random_note)
end

When('I submit the failed assessment form') do
  click_button('Update')
end

Then('the assessment is set to blocked') do
  expect(page).to have_select('Status', selected: 'Blocked')
end

And('my note is stored against the assessment') do
  @note_area = first('article.note')
  expect(@note_area).to have_content(@random_note)
end

And('the note says that the details are #Invalid') do
  expect(@note_area).to have_content('#Invalid')
end

And('the note is of type {string}') do |note_type|
  note_type_strong = @note_area.find('strong')
  expect(note_type_strong).to have_content(note_type)
end
