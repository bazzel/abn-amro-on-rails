# == When
When /^I filter expenses by (creditor "[^"]*")$/ do |creditor|
  # with_scope("aside form.search") do
  #   When %{I check "search_creditor_id_in_#{creditor.id}"}
  #   And %{I press "Search"}
  # end
  with_scope("aside .filter") do
    When %{I follow "#{creditor.name}"}
  end
end

When /^I unfilter expenses by (creditor "[^"]*")$/ do |creditor|
  # with_scope("aside form.search") do
  #   When %{I check "search_creditor_id_in_#{creditor.id}"}
  #   And %{I press "Search"}
  # end
  with_scope("aside .filter #filter_creditor_#{creditor.id}") do
    When %{I follow "x"}
  end
end

When /^I filter expenses by main (category "[^"]*")$/ do |category|
  with_scope("aside form.search") do
    When %{I check "search_category_parent_id_in_#{category.id}"}
    And %{I press "Search"}
  end
end

When /^I filter expenses by sub(category "[^"]*")$/ do |category|
  with_scope("aside form.search") do
    When %{I check "search_category_id_in_#{category.id}"}
    And %{I press "Search"}
  end
end
