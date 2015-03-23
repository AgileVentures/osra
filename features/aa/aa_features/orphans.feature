Feature:
  As a site admin for osra
  So that I may maintain the information about osra orphans
  I would like to be able to read and update orphans in the admin section

  Background:
    Given the following orphans exist:
      | name     | father_given_name | family_name | spon_status | death_date | mother   | birth_date | contact   | o_city  | o_province | o_hood  | c_city  | c_province | c_hood  |
      | Orphan 1 | Father 1          | Familia1    | Sponsored   | 2011-03-15 | Mother 1 | 2012-01-01 | Contact 1 | OCity 1 | Aleppo     | OHood 1 | CCity 1 | Homs       | CHood 1 |
      | Orphan 2 | Father 2          | Familia2    | Unsponsored | 2011-03-15 | Mother 2 | 2011-01-01 | Contact 2 | OCity 2 | Hama       | OHood 2 | CCity 2 | Latakia    | CHood 1 |
    And I am a new, authenticated user

  Scenario: There should be a link to the orphans page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Orphans" linking to the admin orphans index page

  Scenario: There should be a list of orphans on the admin index page
    Given I am on the "Orphans" page for the "Admin" role
    Then I should see "Orphan 1 Father 1"
    And I should see the OSRA number for "Orphan 1"
    And I should see "Orphan Status" for "Orphan 1" set to "Active"
    And I should see "Date of Birth" for "Orphan 1" set to "January 01, 2012"
    And I should see "Mother Alive" for "Orphan 1" set to "Yes"
    And I should see "Father Deceased" for "Orphan 1" set to "Yes"
    And I should see "Gender" for "Orphan 1" set to "Female"
    And I should see "Priority" for "Orphan 1" set to "Normal"
    And I should see "Sponsorship" for "Orphan 1" set to "Sponsored"
    And I should see "Orphan 2 Father 2"

  Scenario: Should not be able to create new orphans directly via the UI
    When I am on the "Orphans" page for the "Admin" role
    Then I should not see the "New Orphan" link

  Scenario: Should be able to visit an orphan from the orphan index page
    Given I am on the "Orphans" page for the "Admin" role
    When I click the "Orphan 1" link
    Then I should be on the "Show Orphan" page for orphan "Orphan 1"

  Scenario: Should be able to edit an orphan from the orphan show page
    Given I am on the "Show Orphan" page for orphan "Orphan 1"
    And I click the "Edit Orphan" button
    Then I should be on the "Edit Orphan" page for orphan "Orphan 1"
    And I should not be able to change "OSRA num" for this orphan
    And I should not be able to change "Orphan Sponsorship Status" for this orphan
    And I fill in "Name" with "Orphan N"
    And I fill in "Date of birth" with "2010-01-01"
    And I fill in "Father given name" with "Father N"
    And I fill in "Family name" with "FamiliaN"
    And I uncheck the "Goes to school" checkbox
    And I fill in "Father occupation" with "Another Occupation"
    And I fill in "Mother name" with "Mother N"
    And I select "Male" from the drop down box for "Gender"
    And I uncheck the "Father is martyr" checkbox
    And I uncheck the "Mother alive" checkbox
    And I uncheck the "Father deceased" checkbox
    And I fill in "Father date of death" with ""
    And I fill in "Father place of death" with ""
    And I fill in "Father cause of death" with ""
    And I fill in "Health status" with "Another Health Status"
    And I fill in "Schooling status" with "Another Schooling Status"
    And I fill in "Guardian name" with "Another Name"
    And I fill in "Guardian relationship" with "Another Relationship"
    And I fill in "Guardian id num" with "56789"
    And I fill in "Contact number" with "Contact N"
    And I fill in "Alt contact number" with "98765"
    And I check the "Sponsored by another org" checkbox
    And I fill in "Another org sponsorship details" with "Other Details"
    And I fill in "Minor siblings count" with "5"
    And I fill in "Sponsored minor siblings count" with "3"
    And I fill in "Comments" with "Other Comments"
    And I select "Inactive" from the drop down box for "Orphan status"
    And I select "High" from the drop down box for "Priority"
    And I fill in "City" in panel "Original Address" with "Another Original City"
    And I fill in "Neighborhood" in panel "Original Address" with "Another Original Neighborhood"
    And I fill in "Street" in panel "Original Address" with "Another Original Street"
    And I fill in "Details" in panel "Original Address" with "Another Original Details"
    And I select "Latakia" from the drop down box for "Province" in panel "Original Address"
    And I fill in "City" in panel "Current Address" with "Another Current City"
    And I fill in "Neighborhood" in panel "Current Address" with "Another Current Neighborhood"
    And I fill in "Street" in panel "Current Address" with "Another Current Street"
    And I fill in "Details" in panel "Current Address" with "Another Current Details"
    And I select "Hama" from the drop down box for "Province" in panel "Current Address"
    And I click the "Update Orphan" button
    Then I should be on the "Show Orphan" page for orphan "Orphan N"
    And I should see "Orphan was successfully updated"
    And I should see the OSRA number for "Orphan N"
    And I should see "Orphan N Father N FamiliaN"
    And I should see "Date Of Birth" set to "January 01, 2010"
    And I should see "Goes To School" set to "No"
    And I should see "Father Occupation" set to "Another Occupation"
    And I should see "Father Place Of Death" set to ""
    And I should see "Father Cause Of Death" set to ""
    And I should see "Father Date Of Death" set to ""
    And I should see "Mother Name" set to "Mother N"
    And I should see "Gender" set to "Male"
    And I should see "Father Is Martyr" set to "No"
    And I should see "Mother Alive" set to "No"
    And I should see "Father Deceased" set to "No"
    And I should see "Health Status" set to "Another Health Status"
    And I should see "Schooling Status" set to "Another Schooling Status"
    And I should see "Guardian Name" set to "Another Name"
    And I should see "Guardian Relationship" set to "Another Relationship"
    And I should see "Guardian Id Num" set to "56789"
    And I should see "Contact Number" set to "Contact N"
    And I should see "Alt Contact Number" set to "98765"
    And I should see "Sponsored By Another Org" set to "Yes"
    And I should see "Another Org Sponsorship Details" set to "Other Details"
    And I should see "Minor Siblings Count" set to "5"
    And I should see "Sponsored Minor Siblings Count" set to "3"
    And I should see "Comments" set to "Other Comments"
    And I should see "Orphan Status" set to "Inactive"
    And I should see "Priority" set to "High"
    And I should see "City" in panel "Original Address" set to "Another Original City"
    And I should see "Neighborhood" in panel "Original Address" set to "Another Original Neighborhood"
    And I should see "Street" in panel "Original Address" set to "Another Original Street"
    And I should see "Details" in panel "Original Address" set to "Another Original Details"
    And I should see "Province" in panel "Original Address" set to "Latakia"
    And I should see "City" in panel "Current Address" set to "Another Current City"
    And I should see "Neighborhood" in panel "Current Address" set to "Another Current Neighborhood"
    And I should see "Street" in panel "Current Address" set to "Another Current Street"
    And I should see "Details" in panel "Current Address" set to "Another Current Details"
    And I should see "Province" in panel "Current Address" set to "Hama"

  Scenario: Should not be able to delete an orphan from the orphan show page
    Given I am on the "Show Orphan" page for orphan "Orphan 1"
    Then I should not see the "Delete Orphan" link

  Scenario: Orphan cannot be older than 22 years of age
    Given I am on the "Edit Orphan" page for orphan "Orphan 1"
    And I fill in "Date of birth" with "1950-01-01"
    And I click the "Update Orphan" button
    Then I should see "Orphan must be younger than 22 years old to join OSRA."

  Scenario: Should return to orphan show page if editing an orphan is cancelled
    Given I am on the "Show Orphan" page for orphan "Orphan 1"
    And I click the "Edit Orphan" button
    And I fill in "Name" with "Orphan N"
    And I click the "Cancel" button
    Then I should be on the "Show Orphan" page for orphan "Orphan 1"
    And I should not see "Orphan N"

