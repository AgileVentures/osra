Feature:
  As an OSRA user
  So that consistency is maintained throughout the application
  I need to make sure that various application entities cannot be inactivated inappropriately

  Background:
    Given an orphan "First Orphan" exists
    And a sponsor "First Sponsor" exists
    And I am a new, authenticated user

  Scenario: Should not be able to set status to "Inactive" for sponsor with active sponsorships
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Sponsor" page for sponsor "First Sponsor"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Sponsor" button
    Then I should see "Cannot inactivate sponsor with active sponsorships"

  Scenario: Should be able to set status to "On Hold" for sponsor with active sponsorships
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Sponsor" page for sponsor "First Sponsor"
    And I select "On Hold" from the drop down box for "Status"
    And I click the "Update Sponsor" button
    Then I should see "Sponsor was successfully updated."

  Scenario: Should be able to inactivate sponsor without active sponsorships
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Sponsor" page for sponsor "First Sponsor"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Sponsor" button
    Then I should see "Sponsor was successfully updated."

  Scenario: Should not be able to inactivate orphan with active sponsorships
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Orphan" page for orphan "First Orphan"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Orphan" button
    Then I should see "Cannot inactivate orphan with active sponsorships"

  Scenario: Should  be able to inactivate orphan without active sponsorships
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Edit Orphan" page for orphan "First Orphan"
    And I select "Inactive" from the drop down box for "Status"
    And I click the "Update Orphan" button
    Then I should see "Orphan was successfully updated."
