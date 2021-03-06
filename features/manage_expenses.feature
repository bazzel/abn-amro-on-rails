Feature: Managing expenses
  In order to control my expenses
  As a role
  I want some pages to view them

  Background:
    Given I am logged in as a user with email "john@example.com" and password "secret"

  Scenario: Viewing the expenses pagw without any uploads
    When I go to the expenses page
    Then I should see "No expenses To view expenses you have to upload a file first."

  Scenario: Viewing the expenses page
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

  Scenario: Selecting creditor for expense
    Given I've uploaded the file "TXT101121100433.TAB"
    And the following creditors exist
      | name |
      | CZ   |
    When I go to the expenses page
    And I follow "Edit" for expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I should see "Expenses" highlighted in the menu
    And I select "CZ" from "Creditor"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | creditor |
      | CZ       |

  Scenario: Add creditor to expense
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I follow "Edit" for expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Or create one" with "CZ"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | creditor |
      | CZ       |

  @javascript
  Scenario: Add creditor to expense through autocomplete
    Given I've uploaded the file "TXT101121100433.TAB"
    And the following creditors exist
      | name |
      | CZ   |
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Creditor" with "C"
    And I select "CZ" from the autocomplete list
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | creditor |
      | CZ       |

  @javascript
  Scenario: Add creditor to expense
    Given I've uploaded the file "TXT101121100433.TAB"
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Creditor" with "CZ"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | creditor |
      | CZ       |

  Scenario: Selecting category for expense
    Given I've uploaded the file "TXT101121100433.TAB"
    And the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    When I go to the expenses page
    And I follow "Edit" for expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I select "Salaris" from "Category"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | category |
      | Salaris  |

  @javascript
  Scenario: Selecting category for expense through autocomplete
    Given I've uploaded the file "TXT101121100433.TAB"
    And the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Category" with "S"
    And I select "Salaris" from the autocomplete list
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | category |
      | Salaris  |

  Scenario: Remember current page
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    When I follow the page link to "2"
    And I follow "Edit" for expense "BETAALD  11-11-10 14U39 803713   ALBERT HEIJN 1521>TILBURG                               PASNR 100"
    And I press "Save"
    And I should see a page link to "1"
    Then I should not see a page link to "2"
