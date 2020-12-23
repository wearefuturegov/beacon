When('I view any needs list row for that resident') do
  visit '/'
  expect(page).to have_text('All needs')
  @resident_row = find_resident_row(@contact.first_name)
  expect(@resident_row).not_to be_nil
end

Then('I see the last contacted date is today') do
  last_contacted_column = @resident_row.find('td:nth-child(9)')
  expect(last_contacted_column).to have_content(Date.today.strftime('%-d %B %Y'))
end

Then('I see one call attempt') do
  call_attempt_column = @resident_row.find('td.column-call-attempts')
  expect(call_attempt_column).to have_content(1)
end

When('I filter needs by category {string}') do |category|
  select category, from: 'category'
end

Then('I see the support action for category {string} in the results') do |category|
  resident_row = find_resident_row(@contact.first_name)
  category_column = resident_row.find('td:nth-child(2)')
  expect(category_column).to have_content(category)
end

Given('many needs exist') do
  # nothing to do, we have needs from the seed data
  visit '/'
  page.should have_content('All needs')
end

When('I sort needs by category in {string} order') do |order|
  visit "/?order=category&order_dir=#{order}&page=1"
end

When('I go the the created and unassigned support action list') do
  visit '/?created_by_me=true'
end

Then('I see the support action for category {string} first in the results') do |category|
  first_row = page.find('table > tbody > tr:nth-child(1)')
  category_column = first_row.find('td:nth-child(2)')
  expect(category_column).to have_content(category)
end

Then('I see every needs with category {string} in the results') do |category|
  page.all('table tr').each do |row|
    category_column = row.find('td:first-child')
    expect(category_column).to have_content(category)
  end
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

  end
  found_row
end
