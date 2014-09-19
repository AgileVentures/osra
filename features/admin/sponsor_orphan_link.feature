Feature:
  As a member of OSRA staff
  So that I can link sponsors with orphans
  I would like to be able to manage sponsorship relations between sponsors and orphans

  Background:
    Given a sponsor "New Sponsor" exists
    And an orphan "Orphan One" exists
    And an orphan "Orphan Two" exists
    And I am a new, authenticated user

  Scenario: Viewing existing sponsorship links between sponsor and orphans
    Given a sponsorship link exists between sponsor "New Sponsor" and orphan "Orphan One"
    And I am on the "Show Sponsor" page for sponsor "New Sponsor"
    Then I should see "1 Sponsored Orphan"
    And I should see "Orphan One"

  Scenario: Pairing a sponsor with an orphan
    Given I am on the "Show Sponsor" page for sponsor "New Sponsor"
    And I click the "Link to Orphan" button
    Then I should be on the "Link to Orphan" page for sponsor "New Sponsor"
    And I should see "Orphan One"
    And I should see "Orphan Two"
    When I click the "Sponsor this orphan" button for orphan "Orphan One"
    Then I should be on the "Show Sponsor" page for sponsor "New Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "Orphan One"

  Scenario: Ending a sponsorship
    Given PENDING: WIP
    Given a sponsorship link exists between sponsor "New Sponsor" and orphan "Orphan One"
    And I am on the "Show Sponsor" page for sponsor "New Sponsor"
    When I click the "End Sponsorship" button for orphan "Orphan One"
    Then I should be on the "Show Sponsor" page for sponsor "New Sponsor"
    And I should see "Sponsorship link was successfully terminated"
    And I should not see "Orphan One"
