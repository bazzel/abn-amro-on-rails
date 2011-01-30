Feature: Manage presets
  In order to add categories and creditors quickly
  As a use
  I want to manage presets for this

  Background:
    Given I am logged in as a user with email "john@example.com" and password "secret"
    And the following creditors exist
      | name |
      | Foo  |
      | Bar  |
    And the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    And the following presets
      | keyphrase               | creditor | category |
      | ALBERT HEIJN            | Foo      | Salaris  |
      | REAAL LEVENSVERZEKERING | Bar      | Salaris  |

  Scenario: Listing presets
    When I go to the home page
    When I follow "Presets" in the menu
    Then I should see "Presets" highlighted in the menu
    And I should see "Listing Presets"
    And I should see the following presets:
      | keyphrase               | creditor | category |
      | ALBERT HEIJN            | Foo      | Salaris  |
      | REAAL LEVENSVERZEKERING | Bar      | Salaris  |

  Scenario: Adding a preset
    When I go to the presets page
    When I follow "New Preset" in the submenu
    Then I should see "Add a new Preset"
    And I should see "New Preset" highlighted in the submenu

  Scenario: Adding a valid preset
    When I go to the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I select "Foo" from "Creditor"
    And I select "Salaris" from "Category"
    And I press "Save"
    Then I should be on the presets page
    And I should see "Preset was successfully created"
    And I should see the following creditors:
      | keyphrase   | creditor | category |
      | My Employer | Foo      | Salaris  |

  @javascript
  Scenario: Selecting category and creditor for preset through autocomplete
    When I go to the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I fill in "Category" with "S"
    And I select "Salaris" from the autocomplete list
    And I fill in "Creditor" with "F"
    And I select "Foo" from the autocomplete list
    And I press "Save"
    Then I should be on the presets page
    And I should see "Preset was successfully created"
    And I should see the following creditors:
      | keyphrase   | creditor | category |
      | My Employer | Foo      | Salaris  |

  @javascript
  Scenario: Add creditor to preset
    When I go to the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I fill in "Category" with "S"
    And I select "Salaris" from the autocomplete list
    And I fill in "Creditor" with "Baz"
    And I press "Save"
    Then I should be on the presets page
    And I should see "Preset was successfully created"
    And I should see the following creditors:
      | keyphrase   | creditor | category |
      | My Employer | Baz      | Salaris  |

  Scenario: Cancelling creation of a preset
    When I go to the new preset page
    And I follow "Cancel"
    Then I should be on the presets page

  Scenario: Adding a preset without a keyphrase
    When I go to the new preset page
    And I select "Foo" from "Creditor"
    And I select "Salaris" from "Category"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Adding a preset without a creditor
    When I go to the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I select "Salaris" from "Category"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Adding a preset without a category
    When I go to the new preset page
    And I fill in "Keyphrase" with "My Employer"
    And I select "Foo" from "Creditor"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Adding a preset with a duplicate keyphrase
    When I go to the new preset page
    And I fill in "Keyphrase" with "ALBERT HEIJN"
    And I select "Foo" from "Creditor"
    And I select "Salaris" from "Category"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This keyphrase already exists. Please enter another one."

  Scenario: Editing an existing preset
    And I am on the presets page
    When I follow "Edit" for preset "ALBERT HEIJN"
    And I fill in "Keyphrase" with "NETTORAMA"
    And I press "Save"
    Then I should see "Preset was successfully updated"
    And I should see the following presets:
      | keyphrase               | creditor | category |
      | NETTORAMA               | Foo      | Salaris  |
      | REAAL LEVENSVERZEKERING | Bar      | Salaris  |

  Scenario: Editing an existing preset with invalid data
    And I am on the presets page
    When I follow "Edit" for preset "ALBERT HEIJN"
    And I fill in "Keyphrase" with ""
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Destroying a preset
    And I am on the presets page
    When I follow "Destroy" for preset "ALBERT HEIJN"
    Then I should be on the presets page
    And I should see "Preset was successfully destroyed"
    And I should not see the following presets:
      | keyphrase | creditor |
      | NETTORAMA | Foo      |

  Scenario: Pagination
    Given 26 presets exist
    When I go to the presets page
    Then I should not see a page link to "1"
    And I should see a page link to "2"
    When I follow the page link to "2"
    Then I should see a page link to "1"
    And I should not see a page link to "2"

  Scenario: Remember current page
    Given 26 presets exist
    When I go to the presets page
    And I follow the page link to "2"
    And I follow "Edit" for preset "Preset 52"
    And I press "Save"
    And I should see a page link to "1"
    Then I should not see a page link to "2"

  Scenario: Preset is destroyed when corresponding creditor is destroyed
    When I go to the creditors page
    And I follow "Destroy" for creditor "Foo"
    And I go to the presets page
    And I should not see the following presets:
    | keyphrase    | creditor |
    | ALBERT HEIJN | Foo      |

  Scenario: Preset is destroyed when corresponding category is destroyed
    When I go to the categories page
    And I follow "Destroy" for category "Salaris"
    And I go to the presets page
    And I should not see the following presets:
    | keyphrase               | creditor | category |
    | ALBERT HEIJN            | Foo      | Salaris  |
    | REAAL LEVENSVERZEKERING | Bar      | Salaris  |
