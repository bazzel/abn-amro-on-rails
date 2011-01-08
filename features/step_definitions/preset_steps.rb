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
