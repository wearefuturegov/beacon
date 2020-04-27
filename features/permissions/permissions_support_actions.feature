@permissions @support_actions
Feature: Restrict viewing/editing support action access to a user based on their role
  As a beacon owner
  I want to restrict what people can see and do with support actions in beacon
  so that data is kept secure

  @list
  Scenario Outline: Can view support actions that are assigned to me
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    When I go to the support actions list
    Then I can see the support action in the list
    Examples:
      | role                            |
      | manager                         |
      | agent                           |
      | mdt                             |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @list
  Scenario Outline: Can view support actions that are assigned to my team
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to that role
    When I go to the support actions list
    Then I can see the support action in the list
    Examples:
      | role                            |
      | manager                         |
      | agent                           |
      | mdt                             |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @list
  Scenario Outline: Certain roles can view support actions that are assigned to a member of their team
    Given I am logged into the system as a "<role>" user
    And another user exists in that role
    And a support action is assigned to the other user
    When I go to the support actions list
    Then I can see the support action in the list
    Examples:
      | role                              |
      | food_delivery_manager             |
      | council_service_adult_social_care |
      | council_service_name_of_service  |

  @list
  Scenario: MDT user cannot see support actions assigned to another MDT user
    Given I am logged into the system as an "MDT" user
    And another user exists in that role
    And a support action is assigned to the other user
    When I go to the support actions list
    Then I can not see that support action in the list

  @edit
  Scenario Outline: Can create support actions when allowed by the role
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    When I go to the contact page for that support action
    Then I should be able to add support actions to that contact
    Examples:
      | role                              |
      | manager                           |
      | agent                             |
      | mdt                               |
      | council_service_adult_social_care |
      | council_service_housing           |

  @edit
  Scenario Outline: Cannot create support actions when not allowed by the role
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    When I go to the contact page for that support action
    Then I should not be able to add support actions to that contact
    Examples:
      | role                  |
      | food_delivery_manager |

  @edit
  Scenario Outline: Can add notes to a support action I have access to edit
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    And I go to the contact page for that support action
    And I add a "Note" note "<note>"
    When I submit the form to create the note
    Then the list of notes contains "<note>"
    Examples:
      | role                              | note                       |
      | manager                           | I'm a manager              |
      | agent                             | Agent makes a comment      |
      | council_service_adult_social_care | Adult social care can help |
      | council_service_housing           | Housing can help           |
      | food_delivery_manager             | Unable to deliver food     |
      | mdt                               | Triage has been postponed  |

  @show
  Scenario Outline: I can see all support actions for a user on the details page
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    And the contact has other support actions that I cannot see in the list
    And I go to the contact page for that support action
    Then I can see the other support actions for that contact
    Examples:
      | role                              |
      | manager                           |
      | agent                             |
      | council_service_adult_social_care |
      | council_service_housing           |
      | mdt                               |

  @show
  Scenario Outline: I can only see relevant support actions for a user on the details page
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    And the contact has other support actions that I cannot see in the list
    And I go to the contact page for that support action
    Then I can not see the other support actions for that contact
    Examples:
      | role                  |
      | food_delivery_manager |

  @show
  Scenario Outline: I can't navigate to support actions I don't have permission to view
    Given I am logged into the system as a "<role>" user
    And a support action is assigned to me
    And the contact has other support actions that I cannot see in the list
    And I go to the url for that other support action
    Then I see a permissions error
    Examples:
      | role                  |
      | food_delivery_manager |