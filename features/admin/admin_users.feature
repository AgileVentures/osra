Feature:
  As a site admin for osra
  So that I may maintain the information about osra admin users
  I would like to be able to create, read and update admin users in the admin section

  Background:
    Given the following admin users exist:
      | email                | password         |
      | admin1@example.com   | 12345678         |
      | admin2@example.com   | 23456789         |
      | admin3@example.com   | 34567890         |
    And I am a new, authenticated user

  Scenario: There should be a link to the admin users page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Admin Users" linking to the admin admin users page

  Scenario: There should be a list of admin users on the admin index page
    Given I am on the "Admin Users" page for the "Admin" role
    Then I should see "admin1@example.com"
    And I should see "admin2@example.com"
    And I should see "admin3@example.com"

  Scenario: Should be able to visit an admin user from the admin user index page
    Given I am on the "Admin Users" page for the "Admin" role
    When I click the "admin1@example.com" link 
    Then I should be on the "Show Admin Users" page for admin user "admin1@example.com"

  Scenario: Should be able to add an admin user from the admin user index page
    Given I am on the "Admin Users" page for the "Admin" role
    And I click the "New Admin User" button
    Then I should be on the "New Admin User" page for the "Admin" role
    And I fill in "Email" with "administrator1@example.com"
    And I fill in "admin_user_password" with "12345678"
    And I fill in "admin_user_password_confirmation" with "12345678"
    And I click the "Create Admin user" button
    Then I should be on the "Show Admin Users" page for admin user "administrator1@example.com"
    And I should see "Admin user was successfully created"
    And I should see "administrator1@example.com"

  Scenario: Should be able to edit an admin user from the admin user show page
    Given I am on the "Show Admin Users" page for admin user "admin1@example.com"
    And I click the "Edit Admin User" button
    Then I should be on the "Edit Admin Users" page for admin user "admin1@example.com"
    And I fill in "Email" with "administrator1@example.com"
    And I fill in "admin_user_password" with "12345678"
    And I fill in "admin_user_password_confirmation" with "12345678"
    And I click the "Update Admin user" button
    Then I should be on the "Show Admin Users" page for admin user "administrator1@example.com"
    And I should see "Admin user was successfully updated"
    And I should see "administrator1@example.com"

  @javascript
  Scenario: Should be able to delete an admin user from the admin user show page
    Given I am on the "Admin Users" page for admin user "admin1@example.com"
    Then I should see the "Delete" link
    And I accept the Delete link for admin user "admin1@example.com"
    Then I should be on the "Admin Users" page for the "Admin" role 
    And I should not see "admin1@example.com"

  @webkit
  Scenario: Should be able to cancel deleting an admin user from the admin user show page
    Given I am on the "Admin Users" page for admin user "admin1@example.com"
    Then I should see the "Delete" link
    And I do not accept the Delete link for admin user "admin1@example.com"
    Then I should be on the "Admin Users" page for the "Admin" role 
    And I should see "admin1@example.com"

