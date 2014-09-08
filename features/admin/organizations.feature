Feature:
  As a site admin for osra
  So that I manage information about OSRA sister organizations
  I need to have an interface that allows CRUD operations on organizations

  Background:
    Given the following organizations exist:
      | code | name | country | region        | start_date | status   | status_code |
      | 11   | Org1 | UK      | Europe        | 01/03/2014 | Active   | 1           |
      | 12   | Org2 | USA     | North America | 02/03/2014 | Inactive | 2           |
      | 13   | Org3 | Canada  | North America | 25/03/2014 | On Hold  | 3           |
    And I am a new, authenticated user

  Scenario: There should be a link to the organizations page on the navbar
    When I am on the admin dashboard page
    Then I should see "Organizations" linking to the admin organizations page

    Scenario: There should be a list of organizations on the admin index page
    When I am on the "Organizations" page for the "Admin" role
    Then I should see "Org1"
    And I should see "Org2"
    And I should see "Org3"

  Scenario: Should be able to visit an organization from the organizations index page
    When I am on the "Organizations" page for the "Admin" role
    And I click the "Org1" link 
    Then I should be on the "Show Organization" page for organization "Org1"

  Scenario: Should be able to edit an organization from the organization show page
    When I am on the "Show Organization" page for organization "Org1"
    And I click the "Edit Organization" button
    Then I should be on the "Edit Organization" page for organization "Org1"
    And I fill in "Region" with "New Region"
    And I click the "Update Organization" button
    Then I should be on the "Show Organization" page for organization "Org1"
    And I should see "Organization was successfully updated"
    And I should see "New Region"

  Scenario: Should not be able to delete an organization from the organization show page
    When I am on the "Show Organization" page for organization "Org1"
    Then I should not see the "Delete Organization" link

