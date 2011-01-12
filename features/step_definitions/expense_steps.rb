# === Transforms
Transform /^expense "([^"]*)"$/ do |description|
  Expense.find_by_description(description)
end

# == Given

# == When
When /^I follow "([^"]*)" for (expense "[^"]*")$/ do |link, expense|
  When %{I follow "#{link}" within "#expense_#{expense.id}"}
end

When /^I check (expense "[^"]*")$/ do |expense|
  When %{I check "expense_ids_#{expense.id}"}
end

When /^I check all expenses$/ do
  When %{I check "toggle_all"}
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
