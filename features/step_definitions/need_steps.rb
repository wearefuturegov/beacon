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
  choose_yes_selected_id_from(need)
end

And('I add another need {string}') do |need|
  choose_yes_selected_id_from(need)
end

And('I submit the add needs form') do
  click_button('Save changes')
end

def choose_yes_selected_id_from(need)
  yes_needs = { phone_triage: 'needs_active_0_true',
                groceries_and_cooked_meals: 'needs_active_1_true',
                physical_and_mental_wellbeing: 'needs_active_2_true',
                financial_support: 'needs_active_3_true',
                staying_social: 'needs_active_4_true',
                prescription_pickups: 'needs_active_5_true',
                book_drops_and_entertainment: 'needs_active_6_true',
                dog_walking: 'needs_active_7_true' }
  radio_id = yes_needs.fetch(need.downcase.gsub(' ', '_').to_sym)
  page.find("label[for=#{radio_id}").click
end
