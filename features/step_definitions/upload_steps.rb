# == Given
Given /^I attach the upload file "([^"]*)" to "([^"]*)"$/ do |file, field|
  file = File.join(Rails.root, "spec/fixtures/upload", file)
  When %{I attach the file "#{file}" to "#{field}"}
end

Given /^I've uploaded the file "([^"]*)"$/ do |file|
  Given %{I am on the new upload page}
  And %{I attach the upload file "#{file}" to "File"}
  And %{I press "Save"}
end

# == Then
# And I should the following upload:
# | file_name           | downloaded_at           |
# | TXT101231141500.TAB | December 31, 2010 14:15 |
Then /^I should the following upload:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within ".content"}
    end
  end
end
