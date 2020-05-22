When('I go to the assessment details page') do
  visit "/needs/#{@need.id}"
end

Then('I see the option to start the assessment') do
  expect(page).to have_content('Start Triage')
end

And('I choose to start the assessment') do
  click_link_or_button 'Start Triage'
end

And('I see the assessment opening questionnaire') do
  expect(page).to have_selector(:link_or_button, 'Yes, continue to triage')
  expect(page).to have_selector(:link_or_button, 'No, describe why')
end

When('I choose to continue the assessment') do
  click_link_or_button 'Yes, continue to triage'
end

Then('I see the assessment triage page') do
  header = page.find('.panel__header-with-arrow')
  expect(header).to have_content 'Triage'
end
