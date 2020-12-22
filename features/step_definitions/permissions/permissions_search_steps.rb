And('another contact {string} is not visible to me') do |name|
  @another_contact = Contact.create!(first_name: name + rand(10**10).to_s(36))
  @another_need = Need.create!(contact: @another_contact, name: 'Dog walking', category: 'Dog walking')
end

Then('I can see the permitted contact in the list') do
  expect(page).to have_text(@contact.first_name)
end

And('I can not see the non-visible contact in the list') do
  expect(page).not_to have_text(@another_contact.first_name)
end
