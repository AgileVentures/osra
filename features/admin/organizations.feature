Feature:
  As a site admin for osra
  So that I manage information about OSRA sister organizations
  I need to have an interface that allows CRUD operations on organizations

  Background:
    Given the following organizations exist:
      | code | name | country | start_date | status   | status_code |
      | 11   | Org1 | UK      | 01/03/2014 | Active   | 1           |
      | 12   | Org2 | USA     | 02/03/2014 | Inactive | 2           |
      | 13   | Org3 | Canada  | 25/03/2014 | On Hold  | 3           |
    And I am a new, authenticated user

  Scenario: There should not be a link to the organizations page on the navbar
    When I am on the admin dashboard page
    Then I should not see "Organizations" linking to the admin organizations page

    Scenario: There should be a list of organizations on the admin index page
    When I am on the "Organizations" page for the "Admin" role
    Then I should see "Org1"
    And I should see "Org2"
    And I should see "Org3"

  Scenario: Should be able to visit an organization from the organizations index page
    When I am on the "Organizations" page for the "Admin" role
    And I click the "Org1" link 
    Then I should be on the "Show Organization" page for organization "Org1"

  Scenario: Should be able to create an organization from the organizations index page
    When I am on the "Organizations" page for the "Admin" role
    And I click the "New Organization" button
    Then I should be on the "New Organization" page for the "Admin" role
    When I fill in new organization form:
      | Field      | Text       |
      | Code       | 55         |
      | Name       | Sampleorg  |
      | Country    | UK         |
      | Start date | 2014-09-08 |

    And I click the "Create Organization" button
    Then I should be on the "Show Organization" page for organization "Sampleorg"
    And I should see "Organization was successfully created."

  Scenario: Should be able to edit an organization from the organization show page
    When I am on the "Show Organization" page for organization "Org1"
    And I click the "Edit Organization" button
    Then I should be on the "Edit Organization" page for organization "Org1"
    And I fill in "Country" with "France"
    And I click the "Update Organization" button
    Then I should be on the "Show Organization" page for organization "Org1"
    And I should see "Organization was successfully updated"
    And I should see "France"

  Scenario: Should not be able to delete an organization from the organization show page
    When I am on the "Show Organization" page for organization "Org1"
    Then I should not see the "Delete Organization" link

