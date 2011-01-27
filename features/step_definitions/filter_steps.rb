# == When
When /^I filter expenses by (creditor "[^"]*")$/ do |creditor|
  with_scope("aside form.search") do
    When %{I check "search_creditor_id_in_#{creditor.id}"}
    And %{I press "Search"}
  end 
end

