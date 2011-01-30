Feature: Unauthorized users
  In order to keep my data secure
  As an admin
  I want to refuse access to guests

  Scenario: Login always pops up
    Given I am a guest
    When I go to the home page
    Then I am on the login page