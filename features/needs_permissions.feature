Feature: Restrict viewing/editing access to a user based on their role
  As a beacon owner
  I want to restrict what people can see and do in beacon
  so that data is kept secure

  Scenario Outline: Can view needs that are assigned to me
    Given I am logged into the system as a "<role>" user
    And a need is assigned to me
    When I go to the need list
    Then I can see the need in the list
    Examples:
      | role    |
      | manager |
      | agent   |
      | mdt     |

  Scenario Outline: Can view needs that are assigned to my team
    Given I am logged into the system as a "<role>" user
    And a need is assigned to that role
    When I go to the need list
    Then I can see the need in the list
    Examples:
      | role    |
      | manager |
      | agent   |
      | mdt     |

  Scenario Outline: Can view needs that are assigned to a member of my team where appropriate
    Given I am logged into the system as a "<role>" user
    And another user exists in that role
    And a need is assigned to the other user
    When I go to the need list
    Then I can see the need in the list
    Examples:
      | role                  |
      | food_delivery_manager |
      | council_service_team  |

  Scenario: MDT user cannot see needs assigned to another MDT user
    Given I am logged into the system as an "MDT" user
    And another user exists in that role
    And a need is assigned to the other user
    When I go to the need list
    Then I can not see that need in the list

  Scenario Outline: Can create needs when allowed by the role
    Given I am logged into the system as a "<role>" user
    And a need is assigned to me
    When I go to the contact page for that need
    Then I should be able to add needs to that contact
    Examples:
      | role                 |
      | manager              |
      | agent                |
      | mdt                  |
      | council_service_team |

  Scenario Outline: Cannot create needs when not allowed by the role
    Given I am logged into the system as a "<role>" user
    And a need is assigned to me
    When I go to the contact page for that need
    Then I should not be able to add needs to that contact
    Examples:
      | role                  |
      | food_delivery_manager |

  Scenario Outline: Can add notes to a need I have access to edit
    Given I am logged into the system as a "<role>" user
    And a need is assigned to me
    And I go to the contact page for that need
    And I add a "Note" note "test"
    When I submit the form to create the note
    Then the list of notes contains "Resident confirmed required help"
    Examples:
      | role                  |
      | food_delivery_manager |