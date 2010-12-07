# == Transform
Transform /^bank account "([^"]*)"$/ do |account_number|
  BankAccount.find_by_account_number(account_number)
end

# == When
When /^I follow "([^"]*)" for (bank account "[^"]*")$/ do |link, bank_account|
  When %{I follow "#{link}" within "tr#bank_account_#{bank_account.id}"}
end

# == Then
Then /^I should see the following bank_accounts:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within ".content"}
    end
  end
end
