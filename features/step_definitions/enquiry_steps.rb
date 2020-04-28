When('I start a new enquiry') do
  click_add_enquiry
  expect(find_enquiry_modal).to be_visible
end

When('I choose to save the triage for later') do
  expect(find_enquiry_modal).to have_content('You can save the triage info and continue later or stay on this page')
  page.find('#save-for-later-btn').click
end

Then('I see a triage saved for draft message') do
  expect(page.find('.notice')).to have_content('Triage temporarily saved.')
end

Then('the new enquiry form is displayed to me') do
  expect(page.find('h1')).to have_content('New Enquiry')
end

When('I choose to stay on the page') do
  page.find('#cancel-modal-btn').click
end

Then('I can still see the triage form') do
  expect(page.find('h1')).to have_content('Add needs')
end

Given('I have a draft triage pending completion') do
  step 'I am on a call with a resident'
  step 'I am conducting a triage of the residents needs'
  page.find('#contact_first_name').set('DraftName')
  page.find('#contact_needs_needs_list_0_start_on').set('01/01/2099')
  step 'I start a new enquiry'
  step 'I choose to save the triage for later'
  step 'the new enquiry form is displayed to me'
end

When('I return to the triage') do
  page.find('#draft-triage-quick-link').click
  step 'I can still see the triage form'
end

Then('I see the triage draft values again') do
  expect(page.find('#contact_first_name').value).to eq('DraftName')
  expect(page.find('#contact_needs_needs_list_0_start_on').value).to eq('01/01/2099')
end

def click_add_enquiry
  page.find('#btnAddEnquiry').click
end

def find_enquiry_modal
  page.find('#modalContent')
end
