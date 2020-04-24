When('I start a new enquiry') do
  click_add_enquiry
  expect(find_enquiry_modal).to be_visible
end

When('I choose to save the triage for later') do
  expect(find_enquiry_modal).to have_content('You can save the triage info and continue later or stay on this page')
  page.find('#save-for-later-btn').click
end

Then('I see a triage saved for draft message') do
  expect(page.find('.notice')).to have_content('Triage temporarely saved.')
end

Then('the new enquiry form is displayed to me') do
    expect(page.find('h1')).to have_content('New Enquiry')
end

def click_add_enquiry
  page.find('#btnAddEnquiry').click
end

def find_enquiry_modal
  page.find('#modalContent')
end
