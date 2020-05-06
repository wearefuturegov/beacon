Given('no notes exists on the support actions') do
  # nothing to do here
end

When("I edit the support action") do
  visit "/needs/#{@contact.needs.first.id}"
end

Then("I can delete the support action") do
  delete_btn = page.find("#delete-need-#{@contact.needs.first.id}")
  expect(delete_btn).to be_visible
  delete_btn.click
  page.accept_alert
end

Then("I can see a deletion confirmation message") do 
  page.find('.notice', text: "'Dog walking' was successfully deleted.")
end
