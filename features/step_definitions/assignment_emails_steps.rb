When('I (assign)/(have assigned) the support action to the role {string}') do |role|
  visit "/needs/#{@need.id}"
  @user_email = @user_email.present? ? @user_email : @user.email
  select2 'need_assigned_to', role
  @expected_assignee = role
  page.find('.notice', text: 'Record successfully updated.')
end

Then('I should receive an email notifying me of the assignment') do
  mail = ActionMailer::Base.deliveries.last
  mail_values = mail.header.fields.map { |f| [f.name, f.unparsed_value] }.to_h
  expect(mail_values['From']).to eq 'help@beacon.support'
  expect(mail_values['To']).to eq 'agent@test.com'
  expect(mail_values['Subject']).to eq 'Send user assigned need email'
end

Then('I should receive an email notifying me of the assignment to my team') do
  mail = ActionMailer::Base.deliveries.last
  mail_values = mail.header.fields.map { |f| [f.name, f.unparsed_value] }.to_h
  expect(mail_values['From']).to eq 'help@beacon.support'
  expect(mail_values['To']).to eq 'council_service_x@test.com'
  expect(mail_values['Subject']).to eq 'Send role assigned need email'
end

When('I choose to notify with emails') do
  find('#send-email').click
end
