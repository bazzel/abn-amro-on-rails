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
