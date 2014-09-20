Feature:
  As an OSRA orphan manager
  So that I can register new orphans in the system
  I would like to be able to upload, validate and save orphan lists the partner sends me and import their orphans

  Background:
    Given the following partners exist:
      | name          | region      | province                   | province_code | contact_details | start_date |
      | Partner1      | Region1     | Damascus & Rif Dimashq     | 11            | 12345           | 2013-09-25 |
    And I am a new, authenticated user

  Scenario: There should not be a link to the orphan lists page on the navbar
    Given I am on the admin dashboard page
    Then I should not see the "Orphan Lists" link

  Scenario: I should see a button for uploading an orphan list on the partner show page
    Given I am on the "Show Partner" page for partner "Partner1"
    Then I should see the "Upload Orphan List" link