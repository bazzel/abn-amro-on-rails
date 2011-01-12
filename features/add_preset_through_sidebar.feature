Feature: Add preset through sidebar
  In order to edit expense efficiently
  As a user
  I want to add missing preset without leaving the expense page

  Scenario: Viewing the category form
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I follow "Edit" for expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    Then I should see a form to add a preset in the sidebar
    And I should not see "Cancel" within "#new_preset"

  Scenario: Redirect to the expense edit view
    Given the following categories
      | name    | parent |
      | Salaris | Inkomen |
    And the following creditors exist
      | name |
      | Foo  |
      | Bar  |
    And I've uploaded the file "TXT101121100433.TAB"
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Keyphrase" with "My Employer" within "#new_preset"
    And I select "Foo" from "Creditor" within "#new_preset"
    And I select "Salaris" from "Category" within "#new_preset"
    And I press "Save" within "#new_preset"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I should see "Preset was successfully created"

  # TODO:
  # Write scenario and implement invalid category