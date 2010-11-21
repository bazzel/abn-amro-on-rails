Feature: Manage uploads
  In order to manage my uploads
  As an authorized user
  I want to view of list of my uploads
  
  Scenario: Listing my uploads
    Given I go to the uploads page
    Then I should see "Listing Uploads"
    And I should see "Uploads" highlighted in the menu
    
  Scenario: New an upload
    Given I go to the uploads page
    When I follow "New Upload" in the submenu
    Then I should see "Add a new Upload"
    And I should see "New Upload" highlighted in the submenu
    And I should see "Uploads" highlighted in the menu
  
  Scenario: Upload no file
    Given I am on the new upload page
    And I press "Save"
    And I should see "There was a problem with your submission. Errors have been highlighted below."
    And I should see "This field is required. Please select a file." for "File"

  Scenario: Upload invalid file
    Given I am on the new upload page
    And I attach the upload file "invalid.pdf" to "File"
    And I press "Save"
    And I should see "There was a problem with your submission. Errors have been highlighted below."
    And I should see "The file must be an Excel file. Please try again." for "File"