Feature:
  As a site admin for osra
  So that I have access to restricted pages
  I would have to authenticate first

  Scenario: Restricted pages should redirect unauthenticated users to login page
    Given I am an unauthenticated user
    When I go to the "partners" page for the "admin" role
    Then I should be on the "login" page for the "admin" role

  Scenario: Restricted pages should be accessibe by authenticated users
    Given I am a new, authenticated user
    When I go to the "partners" page for the "admin" role
    Then I should be on the "partners" page for the "admin" role
