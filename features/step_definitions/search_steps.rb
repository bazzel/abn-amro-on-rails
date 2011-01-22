# == When
When /^I search for "([^"]*)"$/ do |value|
  with_scope("form.search") do
    element = find(:xpath, "//input[@type='search']").set(value)
    And %{I press "Search"}
  end
end

