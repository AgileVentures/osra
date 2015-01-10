Feature:
  As an OSRA admin
  So that I can be sure that the application is not accessible to the public
  I would like to see that protected pages cannot be viewed without authentication

  Scenario: Restricted pages should redirect unauthenticated users to login page
    Given I am an unauthenticated visitor
    Then I should not be able to access protected areas of the application

  Scenario: Restricted pages should be accessibe by authenticated users
    Given I am a new, authenticated visitor
    Then I should be able to access protected areas of the application
