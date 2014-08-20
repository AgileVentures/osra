Feature:
  As a developer
  So that I may maintain the information about osra partners
  I would like to be able to create, read and update partners in the admin section

  Background:
###############################################################
#  need to fix the province situation here and clarify what makes a valid province
#  if the province code is already tied to a specific province prior to the creation 
#  of osra project should this not be seeded into the database?
#  does active record need to be ready only?
##############################################################
    Given the following partners exist:
      | name          | region      | province      | province_code |
      | Partner1      | Region1     | Province1     | 11            |
      | Partner2      | Region2     | Province2     | 12            |
      | Partner3      | Reion3      | Province3     | 13            |

  Scenario: There should be a link to the partners page on the navbar
    Given I am a new, authenticated user
    And I am on the admin dashboard page
    Then I should see "Partners" linking to the admin partners page

  Scenario: There should be a list of partners on the admin index page
    Given I am a new, authenticated user
    And I am on the "Admin Partners" page
    Then I should see "Partner1"
    And I should see "Partner2"
    And I should see "Partner3"

  Scenario: Should be able to visit an partner from the partner index page
    Given I am a new, authenticated user
    And I am on the "Admin Partners" page
    When I click the "Partner1" link 
    Then I should be on the "Admin Partners Show" page for partner "Partner1"

  Scenario: Should be able to edit a partner from the partner show page
    Given I am a new, authenticated user
    And I am on the "Admin Partners Show" page for partner "Partner1"
    And I click the "Edit Partner" button
    Then I should be on the "Admin Partners Edit" page for partner "Partner1"
    And I fill in "Region" with "New Region"
    And I click the "Update Partner" button
    Then I should be on the "Admin Partners Show" page for partner "Partner1"
    And I should see "Partner was successfully updated"
    And I should see "New Region"

  Scenario: Should not be able to delete a partner from the partner show page
    Given I am a new, authenticated user
    And I am on the "Admin Partners Show" page for partner "Partner1"
    Then I should not see the "Delete Partner" link

