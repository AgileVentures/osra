Feature:
  As a site admin for OSRA
  So that I may maintain the information about OSRA agents
  I would like to be able to create, read and update agents in the admin section

  Background:
    Given the following agents exist:
      | agent_name       | email          |
      | Tarek Al Wafai   | tarek@osra.org |
      | Ahmed Abdulmawla | ahmed@osra.org |
    And I am a new, authenticated user

  Scenario: There should be a link to the Agents page on the navbar
    Given I am on the admin dashboard page
    Then I should see "Agents" linking to the admin agents index page

  Scenario: There should be a list of agents on the agents index page
    Given I am on the "Agents" page for the "Admin" role
    Then I should see "Tarek Al Wafai"
    And I should see "Ahmed Abdulmawla"

  Scenario: It should be possible to visit an agent from the agents index page
    Given I am on the "Agents" page for the "Admin" role
    When I click the "Tarek Al Wafai" link
    Then I should be on the "Show Agent" page for agent "Tarek Al Wafai"

  Scenario: Should be able to add an agent from the agents index page
    Given I am on the "Agents" page for the "Admin" role
    And I click the "New Agent" button
    Then I should be on the "New Agent" page for the "Admin" role
    When I fill in "Agent name" with "New Agent"
    And I fill in "Email" with "new_agent@osra.org"
    And I click the "Create Agent" button
    Then I should be on the "Show Agent" page for agent "New Agent"
    And I should see "Agent was successfully created"
    And I should see "new_agent@osra.org"

  Scenario: Should be able to edit an agent from the agent show page
    Given I am on the "Show Agent" page for agent "Tarek Al Wafai"
    And I click the "Edit Agent" button
    Then I should be on the "Edit Agent" page for agent "Tarek Al Wafai"
    When I fill in "Agent name" with "New Agent"
    And I fill in "Email" with "new_agent@osra.org"
    And I click the "Update Agent" button
    Then I should be on the "Show Agent" page for agent "New Agent"
    And I should see "Agent was successfully updated"
    And I should see "new_agent@osra.org"
