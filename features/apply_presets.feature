Feature: Apply presets
  In order to organize my expenses quickly
  As a user
  I want to apply presets by checking one or more expenses

  Background:
  Given the following creditors exist
    | name |
    | Foo  |
    | Bar  |
  And the following categories
    | name    | parent  |
    | Salaris | Inkomen |
  And the following presets
    | keyphrase             | creditor | category     |
    | FORTIS BANK NEDERLAND | Foo      | Salaris      |
    | Nettorama             | Bar      | Boodschappen |
    | ALBERT HEIJN          | Bar      | Boodschappen |
  Given I've uploaded the file "TXT101121100433.TAB"
  When I go to the expenses page

  Scenario: title
    Given I check expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I press "Apply Presets"
    Then I should be on the expenses page for "861887719"
    And I should see "Presets have been applied to 1 expense"
    And I should see the following expenses:
      | creditor | category |
      | Foo      | Salaris  |

  Scenario: title
    Given I check expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I check expense "BETAALD  19-11-10 09U13 2FZK05   Nettorama Oisterwijk>OISTERWIJK                         PASNR 100"
    And I press "Apply Presets"
    Then I should be on the expenses page for "861887719"
    And I should see "Presets have been applied to 2 expenses"
    And I should see the following expenses:
      | creditor | category     |
      | Foo      | Salaris      |
      | Bar      | Boodschappen |

  Scenario: Display alert when no selection is made
    Given I press "Apply Presets"
    Then I should be on the expenses page for "861887719"
    And I should see "Please select one or more expenses and try again."

  @javascript
  Scenario: Check all expenses
    Given I check all expenses
    And I press "Apply Presets"
    Then I should be on the expenses page for "861887719"
    And I should see "Presets have been applied to 6 expenses"
    And I should see the following expenses:
      | creditor | category     |
      | Foo      | Salaris      |
      | Bar      | Boodschappen |

  @javascript
  Scenario: Remember current page
    Given I follow the page link to "2"
    And I check all expenses
    And I press "Apply Presets"
    Then I should be on the expenses page for "861887719"
    Then show me the page
    And I should see a page link to "1"
    Then I should not see a page link to "2"
    And I should see "Presets have been applied to 7 expenses"
    And I should see the following expenses:
      | creditor | category     |
      | Bar      | Boodschappen |
