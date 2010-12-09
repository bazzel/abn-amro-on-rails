Feature: Manage bank accounts
  In order my bank accounts
  As a user
  I want some views for this
  
  Scenario: Listing bank accounts
    Given the following bank_accounts exist
      | account_number | description  |
      | 861887719      | my account   |
      | 972259171      | your account |
    When I go to the home page
    Then I should see "Bank Accounts" highlighted in the menu
    And I should see "Listing Bank Accounts"
    And I should see the following bank_accounts:
      | account_number | description  |
      | 86.18.87.719   | my account   |
      | 97.22.59.171   | your account |

  Scenario: Viewing disabled attributes
    Given a bank_account exists with account_number: "861887719"
    When I go to the home page
    And I follow "Edit" for bank account "861887719"
    Then the "Account number" field should be disabled

  Scenario: Editing an existing bank account
    Given a bank_account exists with account_number: "861887719"
    When I go to the home page
    And I follow "Edit" for bank account "861887719"
    And I fill in "Description" with "my account"
    And I press "Save"
    And I should see "Bank Account was successfully updated"
    And I should see the following bank_accounts:
      | account_number | description  |
      | 86.18.87.719   | my account   |

  # Scenario: Updating an existing bank account with an empty account number
  #   Given a bank_account exists with account_number: "861887719"
  #   When I go to the home page
  #   And I follow "Edit" for bank account "861887719"
  #   And I fill in "Account number" with ""
  #   And I press "Save"
  #   And I should see "There was a problem with your submission."
  #   And I should see "This field is required. Please enter a value."
  #   
  # Scenario: Updating an existing bank account with a duplicate account number
  #   Given the following bank_accounts exist
  #     | account_number | description  |
  #     | 861887719      | my account   |
  #     | 972259171      | your account |
  #   When I go to the home page
  #   And I follow "Edit" for bank account "861887719"
  #   And I fill in "Account number" with "972259171"
  #   And I press "Save"
  #   And I should see "There was a problem with your submission."
  #   And I should see "This account number already exist. Please enter another one."