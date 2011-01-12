# == When
Given /^I check all (.*)$/ do |model|
  When %{I check "toggle_all"}
end

Then /^the "([^\"]*)" field should be disabled$/ do |label|
  # field_labeled(label).should be_disabled
  field_labeled(label)['disabled'].should eql('disabled')
end

Then /^I can not select "([^"]*)" from "([^"]*)"$/ do |value, field|
  pending
end

