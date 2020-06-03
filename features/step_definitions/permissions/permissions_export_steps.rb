Then('I can see the export button') do
  expect(page).to have_selector(:link_or_button, 'Export')
end

Then('I can not see the export button') do
  expect(page).not_to have_selector(:link_or_button, 'Export')
end

And('I can export data from the system') do
  if Capybara.current_driver == :rack_test
    visit '/needs.csv'
    expect(page.response_headers['Content-Type']).to eq 'text/csv'
  end
end

And('I can not export data from the system') do
  if Capybara.current_driver == :rack_test
    visit '/needs.csv'
    expect(page.response_headers['Content-Type']).not_to eq 'text/csv'
  end
end
