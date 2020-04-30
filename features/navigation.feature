Feature: Navigation
  As a contact centre manager
  I want to have predefined filters for certain roles
  so that it is easy to find appropriate support actions

  Scenario Outline: Visible support actions filters
    Given I am logged into the system as a "<role>" user
    When I go to the support actions list
    Then I can see the support action filters
    Examples:
      | role                            |
      | manager                         |
      | agent                           |

  Scenario Outline: Support actions filters are not visible
    Given I am logged into the system as a "<role>" user
    When I go to the support actions list
    Then I can not see the support action filters
    Examples:
      | role                            |
      | mdt                             |
      | council_service_name_of_service |
      | food_delivery_manager           |

  Scenario Outline: Visible team action filters
    Given I am logged into the system as a "<role>" user
    When I go to the support actions list
    Then I can see the team action filters
    Examples:
      | role                            |
      | mdt                             |
      | council_service_name_of_service |
      | food_delivery_manager           |

  Scenario Outline: Team actions filters are not visible
    Given I am logged into the system as a "<role>" user
    When I go to the support actions list
    Then I can not see the team action filters
    Examples:
      | role                            |
      | manager                         |
      | agent                           |