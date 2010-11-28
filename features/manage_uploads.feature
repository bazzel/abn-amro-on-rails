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

  Scenario: Upload invalid file type
    Given I am on the new upload page
    And I attach the upload file "invalid.pdf" to "File"
    And I press "Save"
    And I should see "There was a problem with your submission. Errors have been highlighted below."
    And I should see "The file must be a Tab-delimited text file. Please try again." for "File"

  Scenario: Upload invalid file name
    Given I am on the new upload page
    And I attach the upload file "invalid.TAB" to "File"
    And I press "Save"
    And I should see "There was a problem with your submission. Errors have been highlighted below."
    And I should see "The filename must match the format TXT[yymmddhhmmss].tab. Please try again." for "File"
    But I should not see "The file must be a Tab-delimited text file. Please try again."
    
  Scenario: Upload a valid file
  Given I am on the new upload page
  And I attach the upload file "TXT101231141500.TAB" to "File"
  And I press "Save"
  Then I should be on the upload page for "TXT101231141500.TAB"
  And I should see "'TXT101231141500.TAB' was successfully imported."
  And I should the following upload:
  | file_name           | downloaded_at           | upload_details_count | expenses_count |
  | TXT101231141500.TAB | December 31, 2010 14:15 | 3                    | 3              |
