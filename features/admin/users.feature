Feature:
  As a site admin for OSRA
  So that I may maintain the information about OSRA users
  I would like to be able to create, view and update users in the admin section

  Background:
    Given the following users exist:
      | user_name        | email          |
      | Tarek Al Wafai   | tarek@osra.org |
      | Ahmed Abdulmawla | ahmed@osra.org |
    And I am a new, authenticated user

  Scenario: There should be a link to the Users page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Users" linking to the admin users index page

  Scenario: There should be a list of users on the users index page
    Given I am on the "Users" page for the "Admin" role
    Then I should see "Tarek Al Wafai"
    And I should see "Ahmed Abdulmawla"

  Scenario: It should be possible to visit a user from the users index page
    Given I am on the "Users" page for the "Admin" role
    When I click the "Tarek Al Wafai" link
    Then I should be on the "Show User" page for user "Tarek Al Wafai"

  Scenario: Should be able to add a user from the users index page
    Given I am on the "Users" page for the "Admin" role
    And I click the "New User" button
    Then I should be on the "New User" page for the "Admin" role
    When I fill in "User name" with "New User"
    And I fill in "Email" with "new_user@osra.org"
    And I click the "Create User" button
    Then I should be on the "Show User" page for user "New User"
    And I should see "User was successfully created"
    And I should see "new_user@osra.org"

  Scenario: Should be able to edit a user from the user show page
    Given I am on the "Show User" page for user "Tarek Al Wafai"
    And I click the "Edit User" button
    Then I should be on the "Edit User" page for user "Tarek Al Wafai"
    When I fill in "User name" with "New User"
    And I fill in "Email" with "new_user@osra.org"
    And I click the "Update User" button
    Then I should be on the "Show User" page for user "New User"
    And I should see "User was successfully updated"
    And I should see "new_user@osra.org"

  Scenario: Should be able to see links to assigned sponsors on an user's page
    Given sponsor "Sponsor1" is assigned to user "Tarek Al Wafai"
    And I am on the "Show User" page for user "Tarek Al Wafai"
    Then I should see "Sponsor1" linking to the "Show" page for sponsor "Sponsor1"
