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
    And I attach the upload file "TXT101204150043.TAB" to "File"
    And I press "Save"
    Then I should be on the upload page for "TXT101204150043.TAB"
    And I should see "'TXT101204150043.TAB' was successfully imported."
    And I should the following upload:
      | file_name           | downloaded_at           | upload_details_count | expenses_count |
      | TXT101204150043.TAB | December 04, 2010 15:00 | 7                    | 7              |

  Scenario: Displaying expenses per bank account
    Given I've uploaded the file "TXT101204150043.TAB"
    And I am on the upload page for "TXT101204150043.TAB"
    And I follow "Expenses" in the sidebar
    Then I should see the following expenses:
      | Transaction date | Debit   | Credit | Balance  |
      | 05.15.10         |         | 19.95  | 2,493.55 |
      | 05.16.10         | -115.00 |        | 2,378.55 |
      | 05.16.10         | -52.39  |        | 2,326.16 |
    And I should not see a link to "86.18.87.719" in the sidebar
    And I follow "80.82.57.226" in the sidebar
    Then I should see the following expenses:
      | Transaction date | Debit | Credit   | Balance   |
      | 05.26.10         |       | 5,000.00 | 73,007.45 |
      | 05.29.10         |       | 3,000.00 | 76,007.45 |
    And I should not see a link to "80.82.57.226" in the sidebar
    And I follow "84.55.93.013" in the sidebar
    Then I should see the following expenses:
      | Transaction date | Debit | Credit | Balance |
      | 06.09.10         |       | 65.00  | 351.21  |
      | 06.10.10         |       | 10.00  | 361.21  |
    And I should not see a link to "84.55.93.013" in the sidebar

  Scenario: Show only expenses for current upload
    Given I've uploaded the file "TXT101231141500.TAB"
    And I've uploaded the file "TXT101204150043.TAB"
    And I am on the upload page for "TXT101204150043.TAB"
    And I follow "Expenses" in the sidebar
    Then I should see the following expenses:
      | Transaction date | Debit   | Credit | Balance  |
      | 05.15.10         |         | 19.95  | 2,493.55 |
      | 05.16.10         | -115.00 |        | 2,378.55 |
      | 05.16.10         | -52.39  |        | 2,326.16 |
    And I should not see the following expenses:
      | Transaction date | Debit  |
      | 12.29.10         | -23.99 |
      | 12.30.10         | -27.55 |
      | 12.31.10         | -17.62 |
