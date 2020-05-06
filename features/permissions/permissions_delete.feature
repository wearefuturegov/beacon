@permissions @support_actions
Feature: Restrict deletion of support actions and notes to a user based on their role
  As a beacon owner
  I want to restrict what record people can delete in beacon
  so that data is kept secure

  Scenario Outline: Anyone can delete a need they have created without notes
    Given I am logged into the system as a "<role>" user
    And I have created a support action
    And no notes exists on the support actions
    When I edit the support action
    Then I can delete the support action
    Examples:
      | role                            |
      | mdt                             |
      | food_delivery_manager           |
      | council_service_name_of_service |