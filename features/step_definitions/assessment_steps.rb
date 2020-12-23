And('I am on their profile page') do
  visit "contacts/#{@contact.id}"
end

When('I choose to schedule an assessment') do
  @assessment_type = 'schedule'
  page.find('#btnAssessmentDropdown').click
  page.find('#schedule-assesment-btn').click
end

When('I choose to log an assessment') do
  @assessment_type = 'log'
  page.find('#btnAssessmentDropdown').click
  page.find('#log-assesment-btn').click
end

Then('I see the schedule assessment form') do
  expect(page).to have_field('need[start_on]')
  expect(page).not_to have_field('note[body]')
end

Then('I see the log assessment form') do
  expect(page).not_to have_field('need[start_on]')
  expect(page).to have_field('need_notes_attributes_0_body')
end

And('I enter valid details') do
  page.find('label', text: 'Triage').click
  page.find('#need_name').fill_in(with: 'A task description')
  if @assessment_type == 'log'
    page.find('#need_notes_attributes_0_body').fill_in(with: 'Some call notes')
  elsif @assessment_type == 'schedule'
    @scheduled_date = (Date.today + 1.day)
    page.find('#need_start_on').fill_in(with: @scheduled_date.strftime('%-d/%-m/%Y'))
  end
end

When('I save the assessment') do
  click_button('Save to profile')
end

Then('I see the saved assessment details on the contact') do
  if @assessment_type == 'log'
    completed_link = find('#toggle-visibility-completed-assessment')
    expect(completed_link).to have_content('1 x completed')
  elsif @assessment_type == 'schedule'
    expect(page).to have_content("#{@scheduled_date.strftime('%-d %B %Y')} (Future)")
  end
end
