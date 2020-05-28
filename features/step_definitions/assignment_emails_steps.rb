Given('I can see the support action details') do
end

When('I (assign)/(have assigned) the support action to the role {string}') do |role|
  visit "/needs/#{@need.id}"
  check_email_send
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
  @send_email = true
end

When('I have chosen to notify with emails') do
  step 'I choose to notify with emails'
end

def check_email_send
  if @send_email == true
    find('#send-email').click
    expect(find('#send-email').checked?).to eq(true)
  end
end
