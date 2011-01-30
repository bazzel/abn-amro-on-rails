Feature: Add category through sidebar of preset
  In order to edit presets efficiently
  As a use
  I want to add missing category without leaving the preset page

  Background:
    Given I am logged in as a user with email "john@example.com" and password "secret"

  Scenario: Viewing the category form
    Given I go to the new preset page
    Then I should see a form to add a category in the sidebar
    And I should not see "Cancel" within "#new_category"

  Scenario: Redirect to the preset new view
    Given the following categories
      | name    |
      | Inkomen |
    And the following creditors exist
      | name |
      | Foo  |
      | Bar  |
    And I go to the new preset page
    When I fill in "Name" with "Salaris" within "#new_category"
    And I select "Inkomen" from "Main Category" within "#new_category"
    And I press "Save" within "#new_category"
    Then I should be on the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I select "Foo" from "Creditor"
    And I select "Salaris" from "Category"
    And I press "Save"
    Then I should be on the presets page
    And I should see "Preset was successfully created"
    And I should see the following presets:
      | keyphrase   | creditor | category |
      | My Employer | Foo      | Salaris  |

  Scenario: Redirect to the preset edit view
    Given the following creditors exist
      | name |
      | Foo  |
      | Bar  |
    And the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    And the following presets
      | keyphrase    | creditor | category |
      | ALBERT HEIJN | Foo      | Salaris  |
    And I am on the presets page
    When I follow "Edit" for preset "ALBERT HEIJN"
    When I fill in "Name" with "Bonus" within "#new_category"
    And I select "Inkomen" from "Main Category" within "#new_category"
    And I press "Save" within "#new_category"
    Then I should be on the preset edit page for "ALBERT HEIJN"
    And I select "Bonus" from "Category"
    And I press "Save"
    Then I should be on the presets page
    And I should see "Preset was successfully updated"
    And I should see the following presets:
      | keyphrase    | creditor | category |
      | ALBERT HEIJN | Foo      | Bonus    |

  # TODO:
  # Write scenario and implement invalid category
