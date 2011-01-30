# == Given
Given /^I am a guest$/ do
  true
end

Given /^I am logged in as a user with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  # Given %{I have one user "#{email}" with password "#{password}"}
  Given %{a user "current_user" exists with email: "#{email}", password: "#{password}"}

  And %{I go to the login page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end
