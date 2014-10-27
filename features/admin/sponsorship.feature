Feature:
  As a member of OSRA staff
  So that I can link sponsors with orphans
  I would like to be able to manage sponsorship relations between sponsors and orphans

  Background:
    Given required orphan statuses exist
    And a sponsor "First Sponsor" exists
    And a sponsor "Second Sponsor" exists
    And the sponsor "First Sponsor" has attribute additional_info "Prefer male orphans from Homs"
    And an orphan "First Orphan" exists
    And an orphan "Second Orphan" exists
    And an orphan "Third Orphan" exists
    And I am a new, authenticated user

  Scenario: Viewing existing sponsorship links between sponsor and orphans
    Given a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
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
    And a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And a sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And the status of sponsor "First Sponsor" is "Active"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should not see the "Link to Orphan" link

  Scenario: Pairing a sponsor with orphans
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should be on the "Link to Orphan" page for sponsor "First Sponsor"
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

  Scenario: Allow ordering & filtering of orphans by attributes during sponsorship creation
    Given I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And the orphan "First Orphan" has attribute priority "High"
    And the orphan "First Orphan" has sponsorship_status "Unsponsored"
    And the orphan "Second Orphan" has attribute priority "Normal"
    And the orphan "Second Orphan" has sponsorship_status "Previously Sponsored"
    And the orphan "Third Orphan" has attribute priority "Normal"
    And the orphan "Third Orphan" has sponsorship_status "Unsponsored"
    And I click the "Link to Orphan" button
    Then I should see "Second Orphan" before "First Orphan"
    And I should see "Previously Sponsored" before "Unsponsored"
    And I should not see "Unsponsored" before "Previously Sponsored"
    And I should see "Normal" before "High"
    And I should not see "High" before "Normal"
    When I click the "Name" link
    Then I should see "Second Orphan" before "First Orphan"
    When I click the "Name" link
    Then I should see "First Orphan" before "Second Orphan"
    When I click the "Osra Num" link
    And I click the "Father Name" link
    And I click the "Gender" link
    And I click the "Date Of Birth" link
    And I click the "Original Province" link
    Then I should see "Deir Al-Zor" before "Homs"
    And I should see "Homs" before "Outside Syria"
    And I click the "Original Province" link
    Then I should see "Outside Syria" before "Homs"
    And I should see "Homs" before "Deir Al-Zor"
    And I click the "Partner" link
    And I click the "Father Is Martyr" link
    And I click the "Mother Alive" link
    And I click the "Priority" link
    Then I should see "Normal" before "High"
    And I should not see "High" before "Normal"
    When I click the "Priority" link
    Then I should see "High" before "Normal"
    And I should not see "Normal" before "High"
    When I click the "Orphan Sponsorship Status" link
    Then I should see "Previously Sponsored" before "Unsponsored"
    And I should not see "Unsponsored" before "Previously Sponsored"
    When I click the "Orphan Sponsorship Status" link
    Then I should see "Unsponsored" before "Previously Sponsored"
    And I should not see "Previously Sponsored" before "Unsponsored"
    And I should see "Filters"
    Given I select "Normal" from the drop down box for "Priority"
    And I click the "Filter" button
    Then I should see "Second Orphan"
    And I should see "Third Orphan"
    And I should not see "First Orphan"

  Scenario: Ending a sponsorship
    Given a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    When I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"
    And I should not see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "First Orphan" within "Previously Sponsored Orphans"

  Scenario: Currently sponsored orphans should not be eligible for any new sponsorships
    Given a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"

  Scenario: Cancelling sponsorship creation
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
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
    And a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"

  Scenario: "Request fulfilled" should be automatically set
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "No"
    When a sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "Yes"
    And I should not see the "Link to Orphan" link
    When I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "No"
    And I should see the "Link to Orphan" link
