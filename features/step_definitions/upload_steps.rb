# == Given
Given /^I attach the upload file "([^"]*)" to "([^"]*)"$/ do |file, field|
  file = File.join(Rails.root, "spec/fixtures/upload", file)
  When %{I attach the file "#{file}" to "#{field}"}
end