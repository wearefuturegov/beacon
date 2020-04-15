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
  choose(radio_id, allow_label_click: true)
end
