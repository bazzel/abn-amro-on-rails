Feature: Search expenses
  In order to control my expenses
  As a user
  I want find expenses quickly

  Scenario: Pagination
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page for "861887719"
    And I search for "Kabisa"
    Then I should be on the expenses page for "861887719"
    And I should see the following expenses:
      | description |
      | KABISA      |
    But I should not see the following expenses:
      | description |
      | Nettorama   |
