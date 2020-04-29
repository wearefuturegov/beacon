Feature: Add a new person
  As a call centre agent
  I want to add a new person into beacon
  so that I can help with the person's needs

  Scenario: Add new person
    Given I am logged into the system
    And I chosen to add a new person
    When I add the new person details
    And I save the person form
    Then I see a resident created message