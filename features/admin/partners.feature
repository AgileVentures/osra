Feature:
  As a site admin for osra
  So that I may maintain the information about osra partners
  I would like to be able to create, read and update partners in the admin section

  Background:
    Given the following partners exist:
      | name          | region      | status |province               | contact_details | start_date |
      | Partner1      | Region1     | Active |Damascus & Rif Dimashq | 12345           | 2013-09-25 |
      | Partner2      | Region2     | Active |Aleppo                 | 23456           | 2013-09-25 |
      | Partner3      | Region3     | Active |Homs                   | 34567           | 2013-09-25 |
    And I am a new, authenticated user

  Scenario: There should be a link to the partners page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Partners" linking to the admin partners index page

  Scenario: There should be a list of partners on the admin index page
    Given I am on the "Partners" page for the "Admin" role
    Then I should see "Partner1"
    And I should see "Partner2"
    And I should see "Partner3"

  Scenario: I should see the generated osra numbers on the admin index page
    Given I am on the "Partners" page for the "Admin" role
    Then I should see the following codes for partners:
      | name       | expected_code  |
      | Partner1   | 11001          |
      | Partner2   | 12001          |
      | Partner3   | 13001          |

  Scenario: I should see the required fields on the index page
    Given I am on the "Partners" page for the "Admin" role
    Then I should see the following fields on the page:
    |  field      | value                  |
    |  osra_num   | 11001                  |
    |  name       | Partner1               |
    |  status     | Active                 |
    |  province   | Damascus & Rif Dimashq |
    |  start_date | September 25, 2013     |

  Scenario: I should see the required fields on the partner show page
    Given I am on the "Show Partner" page for partner "Partner1"
    Then I should see the following fields on the page:
    |  field           | value                  |
    |  osra_num        | 11001                  |
    |  name            | Partner1               |
    |  status          | Active                 |
    |  province        | Damascus & Rif Dimashq |
    |  contact_details | 12345                  |
    |  start_date      | September 25, 2013     |

  Scenario: Should be able to visit a partner from the partner index page
    Given I am on the "Partners" page for the "Admin" role
    When I click the "Partner1" link 
    Then I should be on the "Show Partner" page for partner "Partner1"

  Scenario: Should be able to add a partner from the partner index page
    Given I am on the "New Partner" page for the "Admin" role
    And I fill in "Name" with "Partner4"
    And I select "Aleppo" from the drop down box for "Province"
    And I fill in "Region" with "Region1"
    And I click the "Create Partner" button
    Then I should be on the "Show Partner" page for partner "Partner4"
    And I should see "Partner was successfully created"
    And I should see "Partner4"

  Scenario: Should be able to edit a partner from the partner show page
    Given I am on the "Show Partner" page for partner "Partner1"
    And I click the "Edit Partner" button
    Then I should be on the "Edit Partner" page for partner "Partner1"
    And I fill in "Region" with "New Region"
    And I click the "Update Partner" button
    Then I should be on the "Show Partner" page for partner "Partner1"
    And I should see "Partner was successfully updated"
    And I should see "New Region"

  Scenario: Should not be able to edit a partner's province or osra_num
    Given I am on the "Edit Partner" page for partner "Partner1"
    Then I should not be able to change "Province" for this partner
    And I should not be able to change "OSRA num" for this partner

  Scenario: Should not be able to delete a partner from the partner show page
    Given I am on the "Show Partner" page for partner "Partner1"
    Then I should not see the "Delete Partner" link

 Scenario: Should return to partner show page on cancelling edit partner
    Given I am on the "Show Partner" page for partner "Partner1"
    And I click the "Edit Partner" button
    And I fill in "Region" with "New Region"
    And I click the "Cancel" button
    Then I should be on the "Show Partner" page for partner "Partner1"
    And I should not see "New Region"