When('I go to the support actions list') do
  visit '/'
end

And('another user exists in that role') do
  @other_user = User.create!(email: 'other_user@email.com', invited: Date.today, roles: [@role])
end

Then('I should be able to add support actions to that contact') do
  expect(page).to have_selector(:link_or_button, 'Add Needs')
end

Then('I should not be able to add support actions to that contact') do
  expect(page).not_to have_selector(:link_or_button, 'Add Needs')
end

And('the contact has other support actions that I cannot see in the list') do
  @other_need_identifier = rand(10**10).to_s(36) + '@email.com'
  assignee = User.create!(email: @other_need_identifier, invited: Date.today)
  @other_need = Need.create!(contact: @contact, name: 'Other', category: 'Other', status: 'to_do', user: assignee)
end

Then('I can see the other support actions for that contact') do
  needs_panel_header = find('.panel-header__title', text: 'Support Actions')
  needs_section = needs_panel_header.first(:xpath, '../following-sibling::div[@class="panel panel--unpadded"]')
  expect(needs_section).to have_content(@other_need_identifier)
end

Then('I can not see the other support actions for that contact') do
  needs_panel_header = find('.panel-header__title', text: 'Support Actions')
  needs_section = needs_panel_header.first(:xpath, '../following-sibling::div[@class="panel panel--unpadded"]')
  expect(needs_section).not_to have_content(@other_need_identifier)
end

Then('I go to the url for that other support action') do
  visit "/needs/#{@other_need.id}"
end
