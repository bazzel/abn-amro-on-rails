Feature: Manage categories
  In order to manage my categories
  As a user
  I want some views for this

  Scenario: Listing main categories
  Given the following categories
    | name    | parent  |
    | Salaris | Inkomen |
    When I go to the home page
    When I follow "Categories" in the menu
    Then I should see "Categories" highlighted in the menu
    And I should see "Main Categories" highlighted in the submenu
    And I should see "Listing Main Categories"
    And I should see the following categories:
      | name    |
      | Inkomen |
    And I should not see the following categories:
      | name    |
      | Salaris |

  Scenario: Listing subcategories
  Given the following categories
    | name    | parent  |
    | Salaris | Inkomen |
    When I go to the home page
    When I follow "Categories" in the menu
    When I follow "Subcategories" in the submenu
    And I should see "Subcategories" highlighted in the submenu
    And I should see "Listing Subcategories"
    And I should see the following categories:
      | name    | parent  |
      | Salaris | Inkomen |

  Scenario: Adding a category
    When I go to the categories page
    When I follow "New Category" in the submenu
    Then I should see "Add a new Category"
    And I should see "New Category" highlighted in the submenu

  Scenario: Adding a valid main category
    When I go to the new category page
    And I fill in "Name" with "Inkomen"
    And I press "Save"
    Then I should be on the categories page
    And I should see "Category was successfully created"
    And I should see the following categories:
      | name    |
      | Inkomen |

  Scenario: Adding a valid subcategory
    Given the following categories
      | name    |
      | Inkomen |
    When I go to the new category page
    And I fill in "Name" with "Salaris"
    And I select "Inkomen" from "Main Category"
    And I press "Save"
    Then I should be on the categories page
    And I should see "Category was successfully created"
    And I should see the following categories:
      | name    |
      | Salaris |

  Scenario: Cancelling creation of a main category
    Given the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    When I go to the home page
    When I follow "Categories" in the menu
    When I follow "Main Categories" in the submenu
    When I follow "New Category" in the submenu
    And I follow "Cancel"
    Then I should be on the categories page
    And I should see the following categories:
      | name    |
      | Inkomen |
    And I should not see the following categories:
      | name    |
      | Salaris |

  Scenario: Cancelling creation of a subcategory
    Given the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    When I go to the home page
    When I follow "Categories" in the menu
    When I follow "Subcategories" in the submenu
    When I follow "New Category" in the submenu
    And I follow "Cancel"
    Then I should be on the categories page
    And I should see the following categories:
      | name    | parent  |
      | Salaris | Inkomen |

  Scenario: Adding a category without a name
    When I go to the new category page
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Adding a main category with a duplicate name
    Given the following categories
      | name    |
      | Inkomen |
    When I go to the new category page
    And I fill in "Name" with "Inkomen"
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This name already exist. Please enter another one."

  Scenario: Adding a subcategory with the same name as another subcategory but a different parent
    Given the following categories
      | name       | parent  |
      | Overige    | Inkomen |
      | Vrije tijd |         |
    When I go to the new category page
    And I fill in "Name" with "Overige"
    And I select "Vrije tijd" from "Main Category"
    And I press "Save"
    Then I should be on the categories page
    And I should see "Category was successfully created"
    And I should see the following categories:
      | name    | parent     |
      | Overige | Inkomen    |
      | Overige | Vrije tijd |

    Scenario: Editing an existing category
    Given the following categories
      | name    |
      | Inkomen |
      When I go to the main categories page
      And I follow "Edit" for category "Inkomen"
      And I fill in "Name" with "Income"
      And I press "Save"
      Then I should see "Listing Main Categories"
      And I should see "Category was successfully updated"
      And I should see the following categories:
        | name   |
        | Income |

  Scenario: Editing an existing category with invalid data
    Given the following categories
      | name    |
      | Inkomen |
    When I go to the main categories page
    And I follow "Edit" for category "Inkomen"
    And I fill in "Name" with ""
    And I press "Save"
    And I should see "There was a problem with your submission."
    And I should see "This field is required. Please enter a value."

  Scenario: Destroying a creditor
    Given the following categories
      | name    | parent  |
      | Salaris | Inkomen |
    When I go to the main categories page
    And I follow "Destroy" for category "Inkomen"
    Then I should see "Listing Main Categories"
    And I should see "Category was successfully destroyed"
    But I should not see the following categories:
      | name    |
      | Inkomen |
    When I go to the categories page
    Then I should not see the following categories:
      | name    |
      | Salaris |

  Scenario: Pagination
    Given 26 categories exist
    When I go to the main categories page
    Then I should not see a page link to "1"
    And I should see a page link to "2"
    When I follow the page link to "2"
    Then I should see a page link to "1"
    And I should not see a page link to "2"

  Scenario: Remember current page
    Given 26 categories exist
    When I go to the main categories page
    And I follow the page link to "2"
    And I follow "Edit" for category "Category 52"
    And I press "Save"
    And I should see a page link to "1"
    Then I should not see a page link to "2"
