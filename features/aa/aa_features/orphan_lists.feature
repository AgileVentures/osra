Feature:
  As an OSRA orphan manager
  So that I can register new orphans in the system
  I would like to be able to upload, validate and save orphan lists the partner sends me and import their orphans

  Background:
    Given the following partners exist:
      | name     | region   | status   | province | contact_details | start_date |
      | Partner1 | Region1  | Active   |Homs      | 12345           | 2013-09-25 |
      | Partner2 | Region2  | Inactive |Hama      | 98765           | 2012-09-25 |

    And I am a new, authenticated user

  Scenario: There should not be a link to the orphan lists page on the navbar
    Given I am on the admin dashboard page
    Then I should not see the "Orphan Lists" link

  Scenario: I should see a button for uploading an orphan list for an active partner
    Given I am on the "Show Partner" page for partner "Partner1"
    Then I should see the "Upload Orphan List" link

  Scenario: I should not see a button for uploading an orphan list for an inactive partner
    Given I am on the "Show Partner" page for partner "Partner2"
    Then I should not see the "Upload Orphan List" link

  Scenario: I should see the new orphan list form for an active partner
    Given I visit the new orphan list page for partner "Partner1"
    Then I should see "Spreadsheet"

  Scenario: I should not see the new orphan list form for an inactive partner
    Given I visit the new orphan list page for partner "Partner2"
    Then I should not see "Spreadsheet"

  Scenario: I should be able to upload a valid .xlsx orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I should see "was successfully imported"
    And I should see "Registered 3 new orphans"

  Scenario: I should not have a link to see orphan lists for partners with no orphan lists
    Given I visit the new orphan list page for partner "Partner2"
    Then I should see "none"
    And I should not see the "All orphan lists" link

  Scenario: I should have a link to see orphan lists for partners with orphan lists
    Given "Partner1" has the following orphan lists: "three_orphans_xlsx.xlsx", "one_orphan_xlsx.xlsx"
    And I am on the "Show Partner" page for partner "Partner1"
    Then I should see the "All orphan lists" link

  Scenario: I should not see a button for creating a new orphan list
    Given "Partner1" has the following orphan list: "three_orphans_xlsx.xlsx"
    And I am on the "Show Partner" page for partner "Partner1"
    Then I click the "All orphan lists" link
    Then I should not see the "New Orphan List" link

  Scenario: I should not be able to upload an invalid orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_invalid_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I should see "is invalid"
    And I should not see the "Import" link

  Scenario: I should not be able to upload an empty orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "empty_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I should see "is invalid"
    And I should not see the "Import" link

  Scenario: I should not be able to upload if I haven't specified an orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I click the "Upload" button    
    Then I should see "Upload"
    And I should see "Please specify"
    And I should not see the "Import" link

  Scenario: I should be able to upload a valid .xls orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xls.xls" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I should see "was successfully imported"
    And I should see "Registered 1 new orphan"

  Scenario: I should not be able to upload an orphan list file with an invalid extension
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "not_an_excel_file.txt" file
    Then I click the "Upload" button
    Then I should see "is invalid"
    And I should not see the "Import" link

  Scenario: I should be able to see the uploaded orphan list file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I click the "All orphan lists" link
    Then I should see "three_orphans_xlsx.xlsx"

  Scenario: Pending orphan list should be saved to the db when uploading a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I should find pending orphan list "three_orphans_xlsx.xlsx" in the database

  Scenario: Pending orphans should be saved to the db when uploading a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I should find "3" pending orphans for the "three_orphans_xlsx.xlsx" list in the database

  Scenario: Pending orphan list should be deleted from the db after importing a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I should not find pending orphan list "three_orphans_xlsx.xlsx" in the database

  Scenario: Pending orphans should be deleted from the db after importing a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I should find "0" pending orphans for the "three_orphans_xlsx.xlsx" list in the database

  Scenario: Pending orphan list should not be stored in db when user cancels importing a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Cancel" button
    Then I should not find pending orphan list "one_orphan_xlsx.xlsx" in the database

  Scenario: Pending orphans should not be stored in db when user cancels importing a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Cancel" button
    Then I should find "0" pending orphans for the "one_orphan_xlsx.xlsx" list in the database

  Scenario: I should be redirected to partner show view when I cancel uploading a file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xlsx.xlsx" file
    Then I click the "Cancel" button
    Then I should be on the "Show Partner" page for partner "Partner1"

  Scenario: I should be redirected to partner show view when I cancel importing a valid file
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Cancel" button
    Then I should be on the "Show Partner" page for partner "Partner1"

  Scenario: I should be able to see summary details of the orphans to import
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "one_orphan_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I should see "Name1"
    And I should see "نور الدين"
    And I should see "02 January 2012"
    And I should see "Male"

  Scenario: I should be able to see the imported orphans
    Given I visit the new orphan list page for partner "Partner1"
    And I upload the "three_orphans_xlsx.xlsx" file
    Then I click the "Upload" button
    Then I click the "Import" button
    Then I go to the "Orphans" page for the "Admin" role
    Then I should see "الكركيري"

  Scenario: Contact numbers should not be stored as floats
    Given I have already uploaded the "three_orphans_xlsx.xlsx" file for partner "Partner1"
    When I go to the "Orphans" page for the "Admin" role
    And I click the "1300001" link
    Then I should see "963943235556"
    And I should not see "963943235556.0"

  Scenario: I should not be able to import orphan records that fail validations
    Given I have already uploaded the "one_orphan_xlsx.xlsx" file for partner "Partner1"
    And I try to upload the "one_orphan_xlsx.xlsx" file for partner "Partner1" again
    And I should see "Orphan list is invalid"

  Scenario: I should not be able to upload orphan lists with duplicate records
    Given I try to upload the "four_orphans_with_internal_duplicate_xlsx.xlsx" file for partner "Partner1"
    Then I should see "duplicate entries found"
