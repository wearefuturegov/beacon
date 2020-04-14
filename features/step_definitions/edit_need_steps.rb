Given('a resident with a need exists') do
  @contact = Contact.create!(first_name: 'Test')
  @need = Need.create!(contact_id: @contact.id, name: 'Phone Triage', category: 'Phone Triage')
end

When('I am viewing the need') do
  visit "needs/#{@need.id}"
end

When('I assign the need to me') do
  page.select 'admin@test.com', from: 'need_user_id'
end

When('I assign the need to another user') do
  pending
end

When("I change the need status to 'complete'") do
  pending
end

And('the need is assigned to me') do
  pending
end

And("the need has status 'to do'") do
  pending
end

Then("I see the need in the 'assigned to me' page") do
  visit '/?user_id=1'
  table_row = find('tbody tr')
  assignee_column = table_row.find('td:nth-child(7)')
  expect(assignee_column).to have_content 'admin@test.com'
end

And("I see the updated need details in the contact's {string} list") do |area|
  visit "/contacts/#{@contact.id}"
  need_row = get_area_panel(area).find('tbody tr')
  assignee_column = need_row.find('td:nth-child(3)')
  expect(assignee_column).to have_content 'admin@test.com'
end

Then("I no longer see the need in the 'assigned to me' page") do
  pending
end

def get_area_panel(area)
  case area
  when 'needs'
    panel_selector = '.with-left-sidebar__right .panel.panel--unpadded:nth-of-type(1)'
  when 'to do'
    panel_selector = '.with-left-sidebar__right .panel.panel--unpadded:nth-of-type(2)'
  else
    raise "Cannot look for non-existent panel #{area}"
  end
  page.find(panel_selector)
end