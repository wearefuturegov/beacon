And('I am on their profile page') do
  visit "contacts/#{@contact.id}"
end

When('I choose to schedule an assessment') do
  @assessment_type = 'schedule'
  click_link 'Schedule an assessment'
end

When('I choose to log an assessment') do
  @assessment_type = 'log'
  click_link 'Log an assessment'
end

Then('I see the schedule assessment form') do
  expect(page).to have_css('.panel__header', text: 'Schedule an assessment')
  expect(page).to have_field('need[start_on]')
  expect(page).not_to have_field('note[body]')
end

Then('I see the log assessment form') do
  expect(page).to have_css('.panel__header', text: 'Log an assessment')
  expect(page).not_to have_field('need[start_on]')
  expect(page).to have_field('note[body]')
end

And('I enter valid details') do
  page.find('label', text: 'Check in').click
  if @assessment_type == 'log'
    page.find('#note_body').fill_in(with: 'Some call notes')
  elsif @assessment_type == 'schedule'
    page.find('#need_name').fill_in(with: 'A task description')
    @scheduled_date = (Date.today + 1.day)
    page.find('#need_start_on').fill_in(with: @scheduled_date.strftime('%-d/%-m/%Y'))
  end
end

When('I save the assessment') do
  click_button('Save to profile')
end

Then('I see the saved assessment details on the contact') do
  if @assessment_type == 'log'
    completed_link = find('#toggle-visibility-completed-assessments')
    expect(completed_link).to have_content('1 completed assessments')
  elsif @assessment_type == 'schedule'
    assessments_table = find('.assessments-table')
    assessment_row = assessments_table.find('tbody tr')
    expect(assessment_row).to have_content('Check in')
    expect(assessment_row).to have_content("#{@scheduled_date.strftime('%-d %B %Y')} (Future)")
  end
end
