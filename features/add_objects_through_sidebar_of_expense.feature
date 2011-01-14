Feature: Add category through sidebar
  In order to edit expense efficiently
  As a use
  I want to add missing category without leaving the expense page

  Scenario: Viewing the category form
    Given I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I follow "Edit" for expense "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    Then I should see a form to add a category in the sidebar
    And I should not see "Cancel" within "#new_category"

  Scenario: Redirect to the expense edit view
    Given the following categories
      | name    |
      | Inkomen |
    And I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I fill in "Name" with "Salaris" within "#new_category"
    And I select "Inkomen" from "Main Category" within "#new_category"
    And I press "Save" within "#new_category"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I select "Salaris" from "Category"
    And I press "Save"
    Then I should be on the expenses page for "861887719"
    And I should see "Expense was successfully updated"
    And I should see the following expenses:
      | category |
      | Salaris  |

  Scenario: Render expense edit when submitting an invalid preset
    And I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I press "Save" within "#new_preset"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
  And I should not see "There was a problem with your submission." within "#new_preset"
  And I should see "This field is required. Please enter a value." within "#new_preset"
  And I should not see "Cancel" within "#new_preset"

  Scenario: Render expense edit when submitting an invalid category
    And I've uploaded the file "TXT101121100433.TAB"
    When I go to the expenses page
    And I am on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
    And I press "Save" within "#new_category"
    Then I should be on the expense edit page for "UW REKENING MET SALDO IS         ADMINISTRATIEF OVERGEHEVELD VAN  FORTIS BANK NEDERLAND NAAR       ABN AMRO BANK"
  And I should not see "There was a problem with your submission." within "#new_category"
  And I should see "This field is required. Please enter a value." within "#new_category"
  And I should not see "Cancel" within "#new_preset"



  # TODO:
  # Write scenario and implement invalid category