Feature: Search expenses
  In order to control my expenses
  As a user
  I want find expenses quickly

  Scenario: Search expenses on description
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

Scenario: Remember search criteria after returning from edit page
  Given I've uploaded the file "TXT101121100433.TAB"
  When I go to the expenses page for "861887719"
  And I search for "Kabisa"
  And I follow "Edit" for expense "12.27.28.793 KABISA B.V.        DECLARATIE EXTRA REISKOSTEN      SEPTEMBER 2010"
  And I follow "Cancel"
  Then show me the page
  And I should see the following expenses:
    | description |
    | KABISA      |
  But I should not see the following expenses:
    | description |
    | Nettorama   |

  Scenario: Pagination after search
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page for "861887719"
    And I search for "Betaald"
    Then I should see the following expenses:
      | description           |
      | 79G5X9 Saturn Tilburg |
    But I should not see the following expenses:
      | description                |
      | Q1V427 V&D Tilburg>TILBURG |
    And I follow the page link to "2"
    Then I should see the following expenses:
      | description           |
      | Q1V427 V&D Tilburg>TILBURG |
    But I should not see the following expenses:
      | description                |
      | 79G5X9 Saturn Tilburg |

  Scenario: Reset search when switching to other bank account

  Scenario: Search per upload
    Given I've uploaded the file "TXT101231141500.TAB"
    And I've uploaded the file "TXT101204150043.TAB"
    And I am on the upload page for "TXT101204150043.TAB"
    When I follow "Expenses" in the sidebar
    And I search for "Tilburg"
    Then I should see the following expenses:
      | Transaction date | Description                | Debit   | Credit | Balance  |
      | 05.15.10         | Fil.1034>TILBURG PASNR 100 |         | 19.95  | 2,493.55 |
      | 05.16.10         | Gri>TILBURG PASNR 090      | -115.00 |        | 2,378.55 |
    And I should not see the following expenses:
      | Debit  | Description               |
      |  65.00 | W en C Lammers-van Vroon  |
      | -52.39 | VAN OERS                  |
      | -27.55 | ALBERT HEIJN 1521>TILBURG |
  
  Scenario: Search expenses on creditor
    Given the following creditors exist
      | name |
      | CZ   |
    And I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page for "861887719"
    And I follow "Edit" for expense "BETAALD  19-11-10 12U12 4J7QZY   12703 HTC Foodcourt>EINDHOVEN                           PASNR 090"
    And I select "CZ" from "Creditor"
    And I press "Save"
    And I search for "CZ"
    And show me the page
    Then I should see the following expenses:
      | description             | 
      | HTC Foodcourt>EINDHOVEN |
      | CZ ACTIEF IN GEZONDHEID |
  
  Scenario: Search expenses on category
    Given the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    And I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page for "861887719"
    And I follow "Edit" for expense "BETAALD  19-11-10 12U12 4J7QZY   12703 HTC Foodcourt>EINDHOVEN                           PASNR 090"
    And I select "Salaris" from "Category"
    And I press "Save"
    And I search for "Salaris"
    Then I should see the following expenses:
      | description             | 
      | HTC Foodcourt>EINDHOVEN |
      | KABISA B.V.             |
