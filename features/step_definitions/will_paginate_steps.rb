Then /^I should not see a page link to "([^"]*)"$/ do |page|
  # should_not have_css(".pagination .a:contains(#{page})")
  with_scope(".pagination") do
    should_not have_link("#{page}")
  end
end

Then /^I should see a page link to "([^"]*)"$/ do |page|
  # should have_css(".pagination .a:contains(#{page})")
  with_scope(".pagination") do
    should have_link("#{page}")
  end
  # should have_link("#{page}") within ".pagination"
end

When /^I follow the page link to "([^"]*)"$/ do |page|
  When %{I follow "#{page}" within ".pagination"}
end