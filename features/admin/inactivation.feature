Feature:
  As an OSRA user
  So that consistency is maintained across models
  I need to make sure that various application entities cannot be inactivated inappropriately

  Background:
    Given required orphan statuses exist
    And required statuses exist
    And an orphan "First Orphan" exists
    And a sponsor "First Sponsor" exists
    And I am a new, authenticated user

  Scenario: Should not be able to inactivate sponsor with active sponsorships
    Given a sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Sponsor" page for sponsor "First Sponsor"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Sponsor" button
    And I should see "Cannot inactivate sponsor with active sponsorships"

  Scenario: Should be able to inactivate sponsor without active sponsorships
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Sponsor" page for sponsor "First Sponsor"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Sponsor" button
    And I should see "Sponsor was successfully updated."
