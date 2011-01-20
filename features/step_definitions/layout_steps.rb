# == Given

# == When
When /^I follow "([^"]*)" in the menu$/ do |link|
  When %{I follow "#{link}" within "#main-navigation"}
end

When /^I follow "([^"]*)" in the submenu$/ do |link|
  When %{I follow "#{link}" within ".secondary-navigation"}
end

When /^I select "([^"]*)" from the autocomplete list$/ do |link|
  within(:xpath, "//ul[contains(@class, 'ui-autocomplete') and contains(@style,'display: block;')]") do
    page.find('a', :text => link).click
  end
end

# == Then
Then /^I follow "([^"]*)" in the sidebar$/ do |link|
  When %{I follow "#{link}" within "aside .content"}
end


Then /^I should see "([^"]*)" highlighted in the menu$/ do |menu|
  within(:css, '#main-navigation li.active') do
    page.should have_content(menu)
  end
end

Then /^I should see "([^"]*)" highlighted in the submenu$/ do |menu|
  within(:css, '.secondary-navigation li a.current') do
    page.should have_content(menu)
  end
end

Then /^I should see "([^"]*)" in the submenu$/ do |menu|
  within(:css, '.secondary-navigation ul') do
    page.should have_content(menu)
  end
end

Then /^(?:|I )should see the button "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    page.should have_button(text)
  end
end

Then /^(?:|I )should not see the button "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    page.should have_no_button(text)
  end
end

# Then I should see "This field is required. Please select a file." for "File"
Then /^I should see "([^"]*)" for "([^"]*)"$/ do |text, field|
  element = page.find(:xpath, "//li[contains(label, '#{field}')]")
  element.should have_selector('p.inline-errors', :text => text)
end

Then /^I should not see a link to "([^"]*)" in the sidebar$/ do |link|
  within(:css, 'aside .content') do
    page.should_not have_selector('a', :text => link)
  end
end
