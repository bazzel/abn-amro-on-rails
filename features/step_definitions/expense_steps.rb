# === Transforms
Transform /^expense "([^"]*)"$/ do |description|
  Expense.find_by_description(description)
end

# == Given
Given /^the following expenses$/ do |table|
  table.map_column!('creditor') { |creditor_name| Creditor.find_by_name(creditor_name) }
  table.map_column!('category') { |category_name| Category.find_by_name(category_name) }

  table.hashes.each do |attrs|
    expense = Expense.find_by_description(attrs.delete("description"))
    expense.update_attributes(attrs)
  end
end

# == When
When /^I follow "([^"]*)" for (expense "[^"]*")$/ do |link, expense|
  When %{I follow "#{link}" within "#expense_#{expense.id}"}
end

When /^I check (expense "[^"]*")$/ do |expense|
  When %{I check "expense_ids_#{expense.id}"}
end

# == Then
Then /^I should see the following expenses:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within "table"}
    end
  end
end

Then /^I should not see the following expenses:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should not see "#{v}" within "table"}
    end
  end
end
