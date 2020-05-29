Given('the mdt role exists') do
  Role.create(name: 'MDT team', tag: 'mdt')
end

Given('I have assigned needs {string} to {string} for the assessment') do |needs_string, assignees_string|
  needs = needs_string.split(',')
  assignees = assignees_string.split(',')

  visit "/assessments/#{@need.id}/edit"
  needs.each { |n| page.find('label', text: n).click }
  click_link_or_button 'Continue and assign'

  assignment_dropdowns = page.all('.assessment-assign-dropdown')

  if Capybara.current_driver == :rack_test
    assignees.each_with_index do |assignee, index|
      assignment_dropdowns[index].find(:option, assignee).select_option
      check_email_send
    end
  else
    saved_needs = Need.where(assessment_id: @need.id).to_a
    assignees.each_with_index do |assignee, index|
      select2 "assessment_assignment_form_needs_#{saved_needs[index].id}_assigned_to", assignee
      check_email_send
    end
  end

  click_link_or_button 'Update'
end

And('I am on the assessment completion page') do
  page.find('.panel__header-with-arrow', text: 'Complete Triage')
end

Then('I should be informed there are no scheduled further check ins') do
  expect(page).to have_content 'No further reviews currently scheduled'
end

And('the contact for the assessment has a scheduled check in') do
  check_in = Need.new(contact_id: @contact.id, name: 'Check in', category: 'Check in', start_on: DateTime.now + 1.days, status: Need.statuses[:to_do])
  check_in.save
end

Then('I should see the date of the next check in') do
  expect(page).to have_content "Next check in call\nScheduled for #{(DateTime.now + 1.days).strftime('%-d %B %Y')}"
end

When('I complete the assessment') do
  click_link_or_button 'Complete'
end

When('I complete the assessment with the required fields') do
  step 'I schedule a check in for tomorrow'
  step 'I fill in the required fields'
  click_link_or_button 'Complete'
end

When('I schedule a check in for tomorrow') do
  page.find('#assessment_completion_form_next_check_in_date').fill_in(with: (DateTime.now + 1.days).strftime('%d/%m/%Y'))
  page.find('#assessment_completion_form_next_check_in_description').fill_in(with: 'Check in')
end

Then('I should see the future check in') do
  page.find('button#check-in').click
  check_in_row = page.find('.need--check-in')
  expect(check_in_row).to have_content("#{(DateTime.now + 1.days).strftime('%-d %B %Y')} (Future)")
end

And('I fill in the required fields') do
  page.find('label', text: 'Successful Call').click
  page.find('#assessment_completion_form_completion_note').fill_in(with: 'Note body text')
end

And('I create an MDT review') do
  page.find('#assessment_completion_form_mdt_review_note').fill_in(with: 'MDT note body text')
end

Then('I should see the MDT review') do
  page.find('.need--mdt-review')
end

Given('I have completed an assessment') do
  step "I am logged into the system as a 'council_service_x' user"
  step 'the mdt role exists'
  step 'an assessment is assigned to me'
  step 'I have chosen to notify with emails'
  step "I have assigned needs 'Groceries and cooked meals' to 'council_service_x role' for the assessment" 
  step 'I complete the assessment with the required fields'
  step 'I should receive an email notifying me of the assignment to my team'
end

When('I choose to see the assessment') do
  visit "/needs/#{@need.id}/"
end

Then('I cannot see the option to start the assessment') do
  expect(page.find('#start-assessment-disabled-btn').visible?).to be(true)
end