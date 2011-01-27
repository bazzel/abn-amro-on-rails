Feature: Filter expenses
  In order to control my expenses
  As a user
  I want find expenses quickly by using a filter in the sidebar

  Background:
  Given the following creditors exist
    | name   |
    | CZ     |
    | Saturn |
  And I've uploaded the file "TXT101121100433.TAB"
  When I go to the expenses page for "861887719"
  And I follow "Edit" for expense "BETAALD  19-11-10 12U12 4J7QZY   12703 HTC Foodcourt>EINDHOVEN                           PASNR 090"
  And I select "CZ" from "Creditor"
  And I press "Save"
  And I follow "Edit" for expense "BETAALD  19-11-10 10U28 79G5X9   Saturn Tilburg B.V.>TILBURG                             PASNR 100"
  And I select "Saturn" from "Creditor"
  And I press "Save"

  Scenario: Filter expenses by one creditor
    And I filter expenses by creditor "CZ"
    Then I should see the following expenses:
      | description             | 
      | HTC Foodcourt>EINDHOVEN |
    But I should not see the following expenses:
      | description         | 
      | Saturn Tilburg B.V. |
  
  Scenario: Filter expenses by multiple creditors
    When I filter expenses by creditor "CZ"
    And I filter expenses by creditor "Saturn"
    Then I should see the following expenses:
      | description             | 
      | HTC Foodcourt>EINDHOVEN |
      | Saturn Tilburg B.V.     |
