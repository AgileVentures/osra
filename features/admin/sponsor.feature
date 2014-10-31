Feature:
  As a site admin for osra
  So that I may maintain the information about osra sponsors
  I would like to be able to create, read and update sponsors in the admin section

  Background:
    Given the following sponsors exist:
      | name                   | Sponsor1           | Sponsor2            | Sponsor3            |
      | country                | GB                 | CA                  | EE                  |
      | gender                 | Male               | Female              | Male                |
      | requested_orphan_count | 15                 | 1                   | 3                   |
      | sponsor_type           | Individual         | Organization        | Individual          |
      | branch                 | Jeddah             |                     | Jeddah              |
      | organization           |                    | Organization 1      |                     |
      | address                | Address1           | Address2            | Address3            |
      | email                  | email1@example.com | email2@example.com  | email3@example.com  |
      | contact1               | cd1                | cs2                 | cs3                 |
      | contact2               | cd21               | cd22                | cd32                |
      | additional_info        | additional1        | additional2         | addtional3          |
      | start_date             | 2013-09-25         | 2013-09-25          | 2013-09-25          |
      | status                 | Active             | Active              | Active              |
      | status_code            | 01                 | 01                  | 01                  |
      | payment_plan           | Every Two Months   | Annually            | Other               |

    And I am a new, authenticated user

  Scenario: There should be a link to the sponsors index page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Sponsors" linking to the admin sponsors page

  Scenario: There should be a list of sponsors on the sponsors index page
    Given I am on the "Sponsors" page for the "Admin" role
    Then I should see "Sponsor1"
    And I should see "Sponsor2"
    And I should see "Sponsor3"

  Scenario: Should be able to visit a sponsor from the sponsor index page
    Given I am on the "Sponsors" page for the "Admin" role
    When I click the "Sponsor1" link
    Then I should be on the "Show Sponsor" page for sponsor "Sponsor1"
    And I should see "Every Two Months"

  Scenario: Should be able to add a sponsor from the sponsor index page
    Given I am on the "New Sponsor" page for the "Admin" role
    And I fill in "Name" with "Sponsor4"
    And I fill in "Requested orphan count" with "22"
    And I select "Spain" from the drop down box for "Country"
    And I select "Male" from the drop down box for "Gender"
    And I select "Jeddah" from the drop down box for "Branch"
    And I select "Individual" from the drop down box for "Sponsor type"
    And I select "Every Four Months" from the drop down box for "Payment plan"
    And I should not see "Request fulfilled"
    And I click the "Create Sponsor" button
    Then I should be on the "Show Sponsor" page for sponsor "Sponsor4"
    And I should see "Sponsor was successfully created"
    And I should see "Sponsor4"
    And I should see "Every Four Months"

  Scenario: I should see the required fields on the index page
    Given I am on the "Sponsors" page for the "Admin" role
    Then I should see the following fields on the page:
    |  field             | value                  |
    |  name              | Sponsor1               |
    |  country           | United Kingdom         |
    |  gender            | Active                 |
    |  sponsor_type      | Individual             |
    |  status            | Active                 |
    |  start_date        | September 25, 2013     |
    |  request_fulfilled | No                     |

  Scenario: I should see the required fields on the sponsor show page
    Given I am on the "Show Sponsor" page for sponsor "Sponsor1"
    Then I should see the following fields on the page:
    |  field                   | value                  |
    |  name                    | Sponsor1               |
    |  country                 | United Kingdom         |
    |  gender                  | Active                 |
    |  requested_orphan_count  | 15                     |
    |  sponsor_type            | Individual             |
    |  address                 | Address1               |
    |  email                   | email1@example.com     |
    |  contact1                | cd1                    |
    |  contact2                | cd21                   |
    |  additional_info         | additional1            |
    |  status                  | Active                 |
    |  start_date              | September 25, 2013     |
    |  request_fulfilled       | No                     |

  Scenario: Should be able to edit a sponsor from the sponsor show page
    Given I am on the "Show Sponsor" page for sponsor "Sponsor1"
    And I click the "Edit Sponsor" button
    Then I should be on the "Edit Sponsor" page for sponsor "Sponsor1"
    And I should not be able to change "Request fulfilled" for this sponsor
    And I select "Canada" from the drop down box for "Country"
    And I select "Every Six Months" from the drop down box for "Payment plan"
    And I click the "Update Sponsor" button
    Then I should be on the "Show Sponsor" page for sponsor "Sponsor1"
    And I should see "Sponsor was successfully updated"
    And I should see "Canada"
    And I should see "Every Six Months"
    Given  I am on the "Edit Sponsor" page for sponsor "Sponsor1"
    And I select "" from the drop down box for "Payment plan"
    And I click the "Update Sponsor" button
    Then I should not see "is not included in the list"
    And I should see "Sponsor was successfully created"

  Scenario: Should not be able to delete a sponsor from the sponsor show page
    Given I am on the "Show Sponsor" page for sponsor "Sponsor1"
    Then I should not see the "Delete" link

  Scenario: "Request fulfilled" should be updated when "Requested orphan count" changes
    Given an orphan "Orphan1" exists
    And an orphan "Orphan2" exists
    And sponsor "Sponsor1" has requested to sponsor 2 orphans
    And a sponsorship link exists between sponsor "Sponsor1" and orphan "Orphan1"
    And a sponsorship link exists between sponsor "Sponsor1" and orphan "Orphan2"
    When I go to the "Show Sponsor" page for sponsor "Sponsor1"
    Then I should see "Request Fulfilled" set to "Yes"
    When I click the "Edit Sponsor" button
    And I fill in "Requested orphan count" with "3"
    And I click the "Update Sponsor" button
    Then I should be on the "Show Sponsor" page for sponsor "Sponsor1"
    And I should see "Request Fulfilled" set to "No"

  Scenario: Sponsor Type should match affiliation
    Given I am on the "New Sponsor" page for the "Admin" role
    And I select "Jeddah" from the drop down box for "Branch"
    And I select "Organization" from the drop down box for "Sponsor type"
    And I click the "Create Sponsor" button
    Then I should see "Sponsor type must match affiliation"
    When I select "Organization 1" from the drop down box for "Organization"
    And I select "Individual" from the drop down box for "Sponsor type"
    And I select "" from the drop down box for "Branch"
    And I click the "Create Sponsor" button
    Then I should see "Sponsor type must match affiliation"

  Scenario: Should not be able to change Sponsor Type or affiliation for persisted sponsor
    Given I am on the "Edit Sponsor" page for sponsor "Sponsor1"
    Then I should not be able to change "Branch" for this sponsor
    And I should not be able to change "Organization" for this sponsor
    And I should not be able to change "Sponsor Type" for this sponsor

  Scenario: Selectable payment plan for sponsors
    Given I am on the "Sponsors" page for the "Admin" role
    And I click the "Sponsor1" link
    Then I should see "Every Two Months"
    Given I am on the "Sponsors" page for the "Admin" role
    And I click the "Sponsor2" link
    Then I should see "Annually"
    Given I am on the "Sponsors" page for the "Admin" role
    And I click the "Sponsor3" link
    Then I should see "Other"
    Given I click the "Edit Sponsor" button
    And I select "Every Six Months" from the drop down box for "Payment plan"
    And I click the "Update Sponsor" button
    Then I should see "Sponsor was successfully updated"
    Given I am on the "New Sponsor" page for the "Admin" role
    And I fill in "Name" with "Sponsor5"
    And I fill in "Requested orphan count" with "2"
    And I select "Spain" from the drop down box for "Country"
    And I select "Male" from the drop down box for "Gender"
    And I select "Jeddah" from the drop down box for "Branch"
    And I select "Individual" from the drop down box for "Sponsor type"
    And I select "Every Four Months" from the drop down box for "Payment plan"
    And I click the "Create Sponsor" button
    Then I should be on the "Show Sponsor" page for sponsor "Sponsor5"
    And I should see "Sponsor was successfully created"
    And I should see "Sponsor5"
    And I should see "Every Four Months"
    Given I am on the "New Sponsor" page for the "Admin" role
    And I fill in "Name" with "Sponsor6"
    And I fill in "Requested orphan count" with "3"
    And I select "Spain" from the drop down box for "Country"
    And I select "Male" from the drop down box for "Gender"
    And I select "Jeddah" from the drop down box for "Branch"
    And I select "Individual" from the drop down box for "Sponsor type"
    And I click the "Create Sponsor" button
    Then I should see "is not included in the list"
    And I should not see "Sponsor was successfully created"
