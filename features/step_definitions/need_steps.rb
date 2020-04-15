When(/^I add a need for food$/) do
  visit "contacts/#{@contact.id}"
  click_link "#{@contact.first_name}'s Needs (#{@contact.needs.count})"
  click_link 'Add needs'
  # TODO: refactor to test all the needs? Do it from the feature.
  choose 'needs_active_0_true' # 0 is phone triage
  choose 'needs_active_1_true' # 1 is food and groceries
  click_button('Add needs')
end

When('I add needs {string}') do |need|
  visit "contacts/#{@contact.id}"
  click_link 'Triage'
  choose_yes_on_need(page, need)
end

And('I set the start date for the {string} need to {string}') do |need, start_date|
  need_block = find_need_block(page, need)
  start_date_fieldset = find_fieldset(need_block, /scheduled/)
  start_date_fieldset.find('input').fill_in(with: start_date)
end

And('I add another need {string}') do |need|
  choose_yes_on_need(page, need)
end

And('I submit the add needs form') do
  click_button('Save changes')
end

def choose_yes_on_need(element, need)
  need_block = find_need_block(element, need)
  radio_fieldset = find_fieldset(need_block, 'Is this needed?')
  radio_fieldset.find('label', text: 'Yes').click
end

def find_need_block(element, title_text)
  element.find('.triage-grid__title', text: title_text)
         .ancestor('.triage-grid__need')
end

def find_fieldset(element, legend_text)
  element.find('legend', text: legend_text)
         .ancestor('fieldset')
end
