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

  Scenario: Selecting creditor for expense
    Given I've uploaded the file "TXT101121100433.TAB"
    And the following creditors exist
      | name |
      | CZ   |
    When I go to the expenses page
    And I follow "Edit" for expense "66.81.86.739 CZ                 SAL. OKTOBER 2010"
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
    And I follow "Edit" for expense "66.81.86.739 CZ                 SAL. OKTOBER 2010"
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
    When I go to the expenses page
    And I follow "Edit" for expense "66.81.86.739 CZ                 SAL. OKTOBER 2010"
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
    When I go to the expenses page
    And I follow "Edit" for expense "66.81.86.739 CZ                 SAL. OKTOBER 2010"
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
    And I follow "Edit" for expense "66.81.86.739 CZ                 SAL. OKTOBER 2010"
    And I select "Salaris" from "Category"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | category |
      | Salaris  |
