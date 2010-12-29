# === Transforms
Transform /^category "([^"]*)"$/ do |name|
  Category.find_by_name(name)
end

# == Given
Given /^the following categories$/ do |table|
  table.hashes.each do |hash|
    if (parent_name = hash['parent'])
      parent = Category.find_or_create_by_name(parent_name)
      hash['parent'] = parent
    end

    Factory(:category, hash)
  end
end

# == When
When /^I follow "([^"]*)" for (category "[^"]*")$/ do |link, category|
  When %{I follow "#{link}" within "#category_#{category.id}"}
end

# == Then
Then /^I should see the following categories:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within ".content"}
    end
  end
end

Then /^I should not see the following categories:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should not see "#{v}" within ".content"}
    end
  end
end

Then /^I should see a form to add a category in the sidebar$/ do
  page.should have_selector(:css, "aside form#new_category")
end
