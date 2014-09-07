Feature:
  As a site admin for osra
  So that I may maintain the information about osra sponsors
  I would like to be able to create, read and update sponsors in the admin section

  Background:
    Given the following sponsors exist:
      | name          | country     | gender    | sponsor_type    | sponsor_type_code |
      | Sponsor1      | UK          | Male      | Individual      | 1                 |
      | Sponsor2      | Canada      | Female    | Organisation    | 2                 |
      | Sponsor3      | Estonia     | Male      | Individual      | 1                 |
    And I am a new, authenticated user

  Scenario: There should be a link to the sponsors index page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Sponsors" linking to the admin sponsors page

  Scenario: There should be a list of sponsors on the sponsorsindex page
    Given I am on the "Sponsors" page for the "Admin" role
    Then I should see "Sponsor1"
    And I should see "Sponsor2"
    And I should see "Sponsor3"

  Scenario: Should be able to visit an sponsor from the sponsor index page
    Given I am on the "Sponsors" page for the "Admin" role
    When I click the "Sponsor1" link 
    Then I should be on the "Show Sponsors" page for sponsor "Sponsor1"

  Scenario: Should be able to add a sponsor from the sponsor index page
    Given I am on the "New Sponsors" page for the "Admin" role
    And I fill in "Name" with "Sponsor4"
    And I fill in "Country" with "UK"
    And I select "Male" from the drop down box for "Gender"
    And I select "Individual" from the drop down box for "Sponsor type"
    And I click the "Create Sponsor" button
    Then I should be on the "Show Sponsors" page for sponsor "Sponsor4"
    And I should see "Sponsor was successfully created"
    And I should see "Sponsor4"

  Scenario: Should be able to edit a sponsor from the sponsor show page
    Given I am on the "Show Sponsors" page for sponsor "Sponsor1"
    And I click the "Edit Sponsor" button
    Then I should be on the "Edit Sponsors" page for sponsor "Sponsor1"
    And I fill in "Country" with "Canada"
    And I click the "Update Sponsor" button
    Then I should be on the "Show Sponsors" page for sponsor "Sponsor1"
    And I should see "Sponsor was successfully updated"
    And I should see "Canada"

  Scenario: Should not be able to delete a sponsor from the sponsor show page
    Given I am on the "Show Sponsors" page for sponsor "Sponsor1"
    Then I should not see the "Delete" link


