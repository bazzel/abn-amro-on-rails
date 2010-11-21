When /^I follow "([^"]*)" in the submenu$/ do |link|
  When %{I follow "#{link}" within ".secondary-navigation"}
end

Then /^I should see "([^"]*)" highlighted in the menu$/ do |menu|
  within(:css, '#main-navigation li.active') do
    page.should have_content(menu)
  end
end

Then /^I should see "([^"]*)" highlighted in the submenu$/ do |menu|
  within(:css, '.secondary-navigation li.active') do
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