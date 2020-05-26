Given(/^I am logged into the system$/) do
  visit generate_magic_link
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector('#sign-out-link')
end

Given(/^they have logged into the system as an admin$/) do
  step 'I am logged into the system as an admin'
end

Given('they have logged into the system as a {string} user') do |user|
  step "I am logged into the system as a '#{user}' user"
end

Given(/^I am logged into the system as an admin$/) do
  visit generate_magic_link('manager')
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector('#sign-out-link')
end

Given(/^Someone else is logged into the system$/) do
  Capybara.using_session('Second_users_session') do
    visit generate_magic_link('manager')
    expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
    expect(page).to have_selector('#sign-out-link')
  end
end

Given('I am logged into the system as a(n) {string} user') do |role|
  visit generate_magic_link(role.downcase)
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector(:link_or_button, 'Sign out')
end

Given('they have logged out') do
  step 'I logged out'
end

When('I log out') do
  step 'I logged out'
end

Given('I logged out') do
  page.find('#sign-out-link').click
end

def generate_magic_link(role_name = 'agent')
  role = Role.where(name: "#{role_name} role")
  @role = role.exists? ? role.first : Role.create(name: "#{role_name} role", role: role_name)
  email = "#{role_name.parameterize.underscore}@test.com"

  user = User.where(email: email)
  tester = user.exists? ? user.first : User.create!(email: email, invited: Date.today, roles: [@role])
  @user = tester
  session = Passwordless::Session.new({
                                        authenticatable: tester,
                                        user_agent: 'Cucumber-tests',
                                        remote_addr: 'unknown'
                                      })
  session.save!
  magic_link = send(Passwordless.mounted_as).token_sign_in_url(session.token)
  "/sign_in/#{magic_link.split('/').last}"
end
