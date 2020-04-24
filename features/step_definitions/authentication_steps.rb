Given(/^I am logged into the system$/) do
  visit generate_magic_link
  expect(page.status_code).to eq(200) if Capybara.current_driver == :rack_test
  expect(page).to have_selector('#sign-out-link')
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

def generate_magic_link(role = 'agent')
  @role = Role.create(name: "#{role} role", role: role)
  email = role == 'agent' ? 'test@test.com' : 'admin@test.com'
  tester = User.create!(email: email,
                        invited: Date.today,
                        admin: false, roles: [@role])
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
