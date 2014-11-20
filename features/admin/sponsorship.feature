Feature:
  As a member of OSRA staff
  So that I can link sponsors with orphans
  I would like to be able to manage sponsorship relations between sponsors and orphans

  Background:
    Given a sponsor "First Sponsor" exists
    And a sponsor "Second Sponsor" exists
    And the sponsor "First Sponsor" has attribute additional_info "Prefer male orphans from Homs"
    And an orphan "First Orphan" exists
    And an orphan "Second Orphan" exists
    And an orphan "Third Orphan" exists
    And I am a new, authenticated user

  Scenario: Viewing existing sponsorship links between sponsor and orphans
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "1 Currently Sponsored Orphan"
    And I should see "First Orphan"
    When I go to the "Show Orphan" page for orphan "First Orphan"
    Then I should see "Orphan Sponsorship Status" set to "Sponsored"
    And I should see "First Sponsor" linking to the sponsor's page

  Scenario: Sponsorships cannot be created for inactive sponsors
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And the status of sponsor "First Sponsor" is "Inactive"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should not see the "Link to Orphan" link

  Scenario: Sponsorships cannot be created for sponsors whose requests have been fulfilled
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And the status of sponsor "First Sponsor" is "Active"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should not see the "Link to Orphan" link

  Scenario: Pairing a sponsor with orphans
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should be on the Link to Orphan page for sponsor "First Sponsor"
    And I should see "First Sponsor"
    And I should see "Prefer male orphans from Homs"
    And I should see "First Orphan"
    And I should see "Second Orphan"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    When I click the "Link to Orphan" button
    And I click the "Sponsor this orphan" link for orphan "Second Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "Second Orphan" within "Currently Sponsored Orphans"

  Scenario: Ending a sponsorship
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    When I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"
    And I should not see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "First Orphan" within "Previously Sponsored Orphans"

  Scenario: Currently sponsored orphans should not be eligible for any new sponsorships
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"

  Scenario: Cancelling sponsorship creation
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    And I click the "Return to Sponsor page" link
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"

  Scenario: A sponsor should be able to re-sponsor an orphan
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should see "First Orphan"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "First Orphan" within "Previously Sponsored Orphans"

  Scenario: Verifying bug fix for sponsorship inactivation
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"

  Scenario: "Request fulfilled" should be automatically set
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "No"
    When an active sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "Yes"
    And I should not see the "Link to Orphan" link
    When I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "No"
    And I should see the "Link to Orphan" link

  Scenario: Sponsor visible in Orphan list
    Given I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should see html "new_sponsor_panel"
    When I click the "All" button
    Then I should not see html "new_sponsor_panel"
    When I click the "Eligible For Sponsorship" button
    Then I should see html "new_sponsor_panel"
    When I click the "Orphans" link
    Then I should not see html "new_sponsor_panel"

  Scenario: Breadcrumbs on orphan list
    Given I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should see html "admin_root_path_crumb"
    And I should see html "sponsors_path_crumb"
    And I should see html "sponsor_path_crumb"
    Given I click the "Second Sponsor" link
    Then I should be on the "Show Sponsor" page for sponsor "Second Sponsor"
    Given I click the "Orphans" link
    Then I should not see html "sponsors_path_crumb"
    And I should not see html "sponsor_path_crumb"
