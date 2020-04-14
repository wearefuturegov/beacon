Given(/^I am logged into the system$/) do
  visit generate_magic_link
  #expect(page.status_code).to eq(200)
  expect(page).to have_selector(:link_or_button, 'Log out')
end

Given(/^I am logged into the system as an admin$/) do
  visit generate_magic_link(true)
  expect(page.status_code).to eq(200)
  expect(page).to have_selector(:link_or_button, 'Log out')
end

def generate_magic_link(admin = false)
  email = admin ? 'test@test.com' : 'admin@test.com'
  tester = User.create!(email: email,
                        invited: Date.today,
                        admin: admin)
  session = Passwordless::Session.new({
                                        authenticatable: tester,
                                        user_agent: 'Cucumber-tests',
                                        remote_addr: 'unknown'
                                      })
  session.save!
  magic_link = send(Passwordless.mounted_as).token_sign_in_url(session.token)
  "/sign_in/#{magic_link.split('/').last}"
end
