Feature: Manage creditors
  In order to manage my creditor
  As a user
  I want some views for this

  Scenario: Listing creditors
    Given the following creditors exist
      | name |
      | Foo  |
      | Bar  |
      | Baz  |
    When I go to the home page
    When I follow "Creditors" in the menu
    Then I should see "Creditors" highlighted in the menu
    And I should see "Listing Creditors"
    And I should see the following creditors:
      | name |
      | Foo  |
      | Bar  |
      | Baz  |

  Scenario: Adding a creditor
    When I go to the creditors page
    When I follow "New Creditor" in the submenu
    Then I should see "Add a new Creditor"
    And I should see "New Creditor" highlighted in the submenu

  Scenario: Adding a valid creditor
    When I go to the new creditor page
    And I fill in "Name" with "Foo"
    And I press "Save"
    Then I should be on the creditors page
    And I should see "Creditor was successfully created"
    And I should see the following creditors:
      | name |
      | Foo  |

  Scenario: Cancelling creation of a creditor
    When I go to the new creditor page
    And I follow "Cancel"
    Then I should be on the creditors page

    Scenario: Adding a creditor without a name
      When I go to the new creditor page
      And I press "Save"
      And I should see "There was a problem with your submission."
      And I should see "This field is required. Please enter a value."

  Scenario: Adding a creditor with a duplicate name
    Given the following creditors exist
      | name |
      | Foo  |
    When I go to the new creditor page
    And I fill in "Name" with "Foo"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This name already exist. Please enter another one."

  Scenario: Editing an existing creditor
    Given the following creditors exist
      | name |
      | Foo  |
    When I go to the creditors page
    And I follow "Edit" for creditor "Foo"
    And I fill in "Name" with "Bar"
    And I press "Save"
    And I should see "Creditor was successfully updated"
    And I should see the following creditors:
      | name |
      | Bar  |

  Scenario: Editing an existing creditor with invalid data
    Given the following creditors exist
      | name |
      | Foo  |
    When I go to the creditors page
    When I follow "Edit" for creditor "Foo"
    And I fill in "Name" with ""
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Destroying a creditor
  Given the following creditors exist
    | name |
    | Foo  |
    When I go to the creditors page
    When I follow "Destroy" for creditor "Foo"
    Then I should be on the creditors page
    And I should see "Creditor was successfully destroyed"
    And I should not see "Foo"

  Scenario: Pagination
    Given 26 creditors exist
    When I go to the creditors page
    Then I should not see a page link to "1"
    And I should see a page link to "2"
    When I follow the page link to "2"
    Then I should see a page link to "1"
    And I should not see a page link to "2"

  Scenario: Remember current page
    Given 26 creditors exist
    When I go to the creditors page
    And I follow the page link to "2"
    And I follow "Edit" for creditor "Creditor 52"
    And I press "Save"
    And I should see a page link to "1"
    Then I should not see a page link to "2"