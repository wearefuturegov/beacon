Feature: Add a new person
  As a an internal council
  I want to add a new person into beacon
  so that I can help with the person's needs

  Scenario Outline: Add new person
    Given I am logged into the system as a "<role>" user
    And I chosen to add a new person
    When I add the new person details
    And I save the person form
    Then I see a resident created message
    Examples: 
      | role                              |
      | manager                           |
      | agent                             |
      | mdt                               |
      | council_service_adult_social_care |
      | council_service_housing           |