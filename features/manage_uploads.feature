Feature: Manage uploads
  In order to manage my uploads
  As an authorized user
  I want to view of list of my uploads
  
  Scenario: Listing my uploads
    Given I go to the uploads page
    Then I should see "Listing Uploads"
    And I should see "Uploads" highlighted in the menu
    
  Scenario: Adding an upload
    Given I go to the uploads page
    When I follow "New Upload" in the submenu
    Then I should see "Add a new Upload"
    And I should see "New Upload" highlighted in the submenu
    And I should see "Uploads" highlighted in the menu
  