# === Transforms
Transform /^creditor "([^"]*)"$/ do |name|
  Creditor.find_by_name(name)
end

# == When
When /^I follow "([^"]*)" for (creditor "[^"]*")$/ do |link, creditor|
  When %{I follow "#{link}" within "#creditor_#{creditor.id}"}
end

# == Then
Then /^I should see the following creditors:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within ".content"}
    end
  end
end
