Feature: Search expenses
  In order to control my expenses
  As a user
  I want find expenses quickly

  Scenario: Search expenses
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
    And I follow "Expenses" in the sidebar
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
