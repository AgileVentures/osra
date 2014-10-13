Feature:
  As a site admin for osra
  So that I may quickly find the pertinent information
  I would like to be able to filter records in the index view

  Background:
    Given I am a new, authenticated user

  Scenario: I should be able to filter Sponsors based on gender
    Given I am on the "Sponsors" page for the "Admin" role
    And I have 3 male sponsors and 2 female sponsors
    Then I should see a "Gender" drop down box in the "Filters" section with options: "Male", "Female"
#    When I select Male then I should see only male sponsors
#    And If I select Female then I should see only female sponsors
