When('I view any needs list row for that resident') do
  visit '/'
  @resident_row = find_resident_row(@contact.first_name)
  expect(@resident_row).not_to be_nil
end

Then('I see the last contacted date is today') do
  last_contacted_column = @resident_row.find('td:last-child')
  expect(last_contacted_column).to have_content(Date.today.strftime('%-d %B %Y'))
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
    break if !next_button || next_button[:class].include?('pagination__next--disabled')

    next_button.click
  end
  found_row
end
