Feature: Apply presets
  In order to organize my expenses quickly
  As a user
  I want to apply presets by checking one or more presets

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
  When I go to the presets page

  Scenario: Apply a single preset
    Given I check preset "ALBERT HEIJN"
    And I press "Apply Presets"
    Then I should be on the presets page
    And I should see "Presets have been applied to 14 expenses"

  Scenario: Display alert when no selection is made
    Given I press "Apply Presets"
    Then I should be on the presets page
    And I should see "Please select one or more presets and try again."

  @javascript
  Scenario: Check all presets
    Given I check all presets
    And I press "Apply Presets"
    Then I should be on the presets page
    And I should see "Presets have been applied to 20 expenses"

  # @javascript
  # Scenario: Remember current page
  #   Given I follow the page link to "2"
  #   And I check all expenses
  #   And I press "Apply Presets"
  #   Then I should be on the expenses page for "861887719"
  #   And I should see a page link to "1"
  #   Then I should not see a page link to "2"
  #   And I should see "Presets have been applied to 7 expenses"
  #   And I should see the following expenses:
  #     | creditor | category     |
  #     | Bar      | Boodschappen |
