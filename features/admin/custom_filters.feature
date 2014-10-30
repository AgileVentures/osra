Feature:
  As a site admin for osra
  So that I may quickly find the pertinent information
  I would like to be able to filter records in the index view

  Background:
    Given I am a new, authenticated user

  Scenario: I should be able to filter Sponsors based on gender
    Given I am on the "Sponsors" page for the "Admin" role
    And there are 3 male and 2 female sponsors
    Then I should see a "Gender" drop down box in the "Filters" section with options: "Male", "Female"
    When I select "Male" from "Gender"
    Then I should see only male sponsors
    When I select "Female" from "Gender"
    Then I should see only female sponsors

  Scenario: I should be able to filter Orphans based on gender
    Given I am on the "Orphans" page for the "Admin" role
    And there are 2 male and 3 female orphans
    Then I should see a "Gender" drop down box in the "Filters" section with options: "Male", "Female"
    When I select "Male" from "Gender"
    Then I should see only male orphans
    When I select "Female" from "Gender"
    Then I should see only female orphans