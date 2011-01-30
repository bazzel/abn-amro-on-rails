Feature: Authorized users
  In order to leave the app when I want
  As a user
  I want a logout feature

  Scenario: Logging out
    Given I am logged in as a user with email "john@example.com" and password "secret"
    When I follow "Sign out"
    Then I should be on the login page