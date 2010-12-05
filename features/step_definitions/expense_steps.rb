# == Given

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
