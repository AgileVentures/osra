Feature:
  As a site admin for OSRA
  So that I may maintain the information about OSRA users
  I would like to be able to create, view and update users in the admin section

  Background:
    Given the following users exist:
      | user_name    | email              |
      | First User   | first@example.com  |
      | Second User  | second@example.com |
    And I am a new, authenticated user

  Scenario: There should be a link to the Users page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Users" linking to the admin users index page

  Scenario: There should be a list of users on the users index page
    Given I am on the "Users" page for the "Admin" role
    Then I should see "First User"
    And I should see "Second User"

  Scenario: It should be possible to visit a user from the users index page
    Given I am on the "Users" page for the "Admin" role
    When I click the "First User" link
    Then I should be on the "Show User" page for user "First User"

  Scenario: Should be able to add a user from the users index page
    Given I am on the "Users" page for the "Admin" role
    And I click the "New User" button
    Then I should be on the "New User" page for the "Admin" role
    When I fill in "User name" with "New User"
    And I fill in "Email" with "new_user@example.com"
    And I click the "Create User" button
    Then I should be on the "Show User" page for user "New User"
    And I should see "User was successfully created"
    And I should see "new_user@example.com"

  Scenario: Should be able to edit a user from the user show page
    Given I am on the "Show User" page for user "First User"
    And I click the "Edit User" button
    Then I should be on the "Edit User" page for user "First User"
    When I fill in "User name" with "New User"
    And I fill in "Email" with "new_user@osra.org"
    And I click the "Update User" button
    Then I should be on the "Show User" page for user "New User"
    And I should see "User was successfully updated"
    And I should see "new_user@osra.org"

  Scenario: Should be able to see links to assigned sponsors on a user's page
    Given an active sponsor "Sponsor1" is assigned to user "First User"
    And an inactive sponsor "Sponsor2" is assigned to user "First User"
    And I am on the "Show User" page for user "First User"
    Then I should see "Sponsor1" within "Active Sponsors"
    And I should not see "Sponsor2" within "Active Sponsors"
    And I should see "Sponsor2" within "Inactive Sponsors"
    And I should not see "Sponsor1" within "Inactive Sponsors"
    And "Sponsor1" should link to the "Show" page for sponsor "Sponsor1"
    And "Sponsor2" should link to the "Show" page for sponsor "Sponsor2"

  Scenario: Sponsor info should only show the number of actively sponsored orphans
    Given an active sponsor "Sponsor1" is assigned to user "First User"
    And an inactive sponsorship link exists between sponsor "Sponsor1" and orphan "Orphan1"
    And an active sponsorship link exists between sponsor "Sponsor1" and orphan "Orphan2"
