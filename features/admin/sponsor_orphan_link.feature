Feature:
  As a member of OSRA staff
  So that I can link sponsors with orphans
  I would like to be able to manage sponsorship relations between sponsors and orphans

  Background:
    Given a sponsor "New Sponsor" exists
    And the sponsor "New Sponsor" has attribute additional_info "Prefer male orphans from Homs"
    And required orphan statuses exist
    And an orphan "First Orphan" exists
    And an orphan "Second Orphan" exists
    And I am a new, authenticated user

  Scenario: Viewing existing sponsorship links between sponsor and orphans
    Given a sponsorship link exists between sponsor "New Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "New Sponsor"
    Then I should see "1 Sponsored Orphan"
    And I should see "First Orphan"

  Scenario: Pairing a sponsor with orphans
    Given I am on the "Show Sponsor" page for sponsor "New Sponsor"
    And I click the "Link to Orphan" button
    Then I should be on the "Link to Orphan" page for sponsor "New Sponsor"
    And I should see "New Sponsor"
    And I should see "Prefer male orphans from Homs"
    And I should see "First Orphan"
    And I should see "Second Orphan"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "New Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan"
    When I click the "Link to Orphan" button
    And I click the "Sponsor this orphan" link for orphan "Second Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "New Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan"
    And I should see "Second Orphan"

  Scenario: Ending a sponsorship
    Given a sponsorship link exists between sponsor "New Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "New Sponsor"
    When I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "New Sponsor"
    And I should see "Sponsorship link was successfully terminated"
    And I should not see "First Orphan"

  Scenario: A sponsor cannot create two sponsorship links with the same orphan
    Given a sponsorship link exists between sponsor "New Sponsor" and orphan "First Orphan"
    When I am on the "Link to Orphan" page for sponsor "New Sponsor"
    Then I should not see "First Orphan" 
