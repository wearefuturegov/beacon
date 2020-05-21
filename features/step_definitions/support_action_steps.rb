Given('I have created a support action {string}') do |support_action|
  step 'a unique resident'
  step "I add needs \"#{support_action}\""
  step 'I submit the add needs form'
end

When('I add needs {string}') do |support_action|
  visit "/contacts/#{@contact.id}"
  click_link 'Add needs +'
  choose_yes_on_support_action(page, support_action)
end

When('I add needs') do
  visit "/contacts/#{@contact.id}"
  click_link 'Add needs +'
end

Then('I should not be able to add {string}') do |assessment_type|
  needs = page.all('.triage-grid__title')
  # sanity check
  expect(needs.select{|need| need.text.include?('Groceries and cooked meals')}.size).to eq 1
  # should not contain the assessment_type
  expect(needs.select{|need| need.text.include?(assessment_type)}.size).to eq 0
end

And('I set the start date for the {string} support action to {string}') do |support_action, start_date|
  support_action_block = find_support_action_block(page, support_action)
  start_date_fieldset = find_fieldset(support_action_block, /scheduled/)
  start_date_fieldset.find('input').fill_in(with: start_date)
end

And('I add another support action {string}') do |support_action|
  choose_yes_on_support_action(page, support_action)
end

And('I submit the add needs form') do
  click_button('Save changes')
  @need = Need.order(:created_at).last
end

Then('I see an error message {string}') do |error|
  errors = find('#error_explanation')
  expect(errors).to have_content(error)
end

def choose_yes_on_support_action(element, support_action)
  element.find('label', text: support_action).click
end

def find_support_action_block(element, title_text)
  element.find('.triage-grid__title', text: title_text)
         .ancestor('.triage-grid__need')
end

def find_fieldset(element, legend_text)
  element.find('legend', text: legend_text)
         .ancestor('fieldset')
end
