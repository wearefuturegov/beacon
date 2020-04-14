Given('a unique resident with a {string} need') do |need|
  @contact = Contact.create!(first_name: 'Test' + rand(10**10).to_s(36))
  step "I add needs \"#{need}\""
  step 'I submit the add needs form'
end

When('I view any needs list row for that resident') do
  visit '/'
  @resident_row = find_resident_row(@contact.first_name)
  expect(@resident_row).to exist
end

Then('I see the last contacted date is today') do
  last_contacted_column = @resident_row.find('td:last-child')
  expect(last_contacted_column).to have_content('test')
end

def find_resident_row(resident_name)
  found_row = nil
  until found_row
    page.all('table tr').each do |row|
      if row.has_content?(resident_name)
        found_row = row
        break
      end
    end

    next_button = page.find('.pagination__next')
    if !next_button || next_button[:class].include?('pagination__next--disabled')
      break
    else
      next_button.click
    end
  end
  found_row
end
