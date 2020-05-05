@permissions @export
Feature: Restrict exporting need data depending on role
  As a beacon owner
  I want to restrict which roles can export data in beacon
  so that only specific roles can take data out of the system

  Scenario Outline: Roles that can see export functionality
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    When I go to the support actions list
    Then I can see the export button
    And I can export data from the system
    Examples:
      | role                  |
      | manager               |
      | food_delivery_manager |

  Scenario Outline: Roles that cannot see export functionality
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    When I go to the support actions list
    Then I can not see the export button
    And I can not export data from the system
    Examples:
      | role                     |
      | agent                    |
      | mdt                      |
      | council_service_anything |