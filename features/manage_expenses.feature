Feature: Managing expenses
  In order to control my expenses
  As a role
  I want some pages to view them
  
Scenario: title
  Given I've uploaded the file "TXT101204150043.TAB"
  When I follow "Expenses" in the menu
  Then I should be on the expenses page
  And I should see "Expenses" highlighted in the menu
  
Scenario: Pagination
  Given I've uploaded the file "TXT101121100433.TAB"
  When I go to the expenses page
  Then I should not see a page link to "1"
  And I should see a page link to "2"
  When I follow the page link to "2"
  Then I should see a page link to "1"
  And I should not see a page link to "2"