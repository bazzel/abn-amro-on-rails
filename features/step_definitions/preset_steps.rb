# === Transforms
Transform /^preset "([^"]*)"$/ do |keyphrase|
  Preset.find_by_keyphrase(keyphrase)
end

# == Given
Given /^the following presets$/ do |table|
  table.hashes.each do |hash|
    if (category_name = hash['category'])
      category = Category.find_or_create_by_name(category_name)
      hash['category'] = category
    end

    if (creditor_name = hash['creditor'])
      creditor = Creditor.find_or_create_by_name(creditor_name)
      hash['creditor'] = creditor
    end

    Factory(:preset, hash)
  end
end

# == When
When /^I follow "([^"]*)" for (preset "[^"]*")$/ do |link, preset|
  When %{I follow "#{link}" within "#preset_#{preset.id}"}
end

When /^I check (preset "[^"]*")$/ do |preset|
  When %{I check "preset_ids_#{preset.id}"}
end

Given /^I apply preset "([^"]*)" twice$/ do |preset|
  2.times do
    Given %{I check preset "#{preset}"}
    And %{I press "Apply Presets"}
  end
end


# Moved to additional_web_steps.rb
# Given /^I check all presets$/ do
#   When %{I check "toggle_all"}
# end

Then /^I should see a form to add a preset in the sidebar$/ do
  page.should have_selector(:css, "aside form#new_preset")
end


# == Then
Then /^I should see the following presets:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should see "#{v}" within ".content"}
    end
  end
end

Then /^I should not see the following presets:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |k, v|
      Then %{I should not see "#{v}" within ".content"}
    end
  end
end
