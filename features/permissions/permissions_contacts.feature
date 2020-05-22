@permissions @contacts
Feature: Restrict viewing/editing contact access to a user based on their role
  As a beacon owner
  I want to restrict what people can see and do with contacts in beacon
  so that data is kept secure

  @list
  Scenario Outline: Can view contacts with needs that are assigned to me
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    When I go to the contact list
    Then I can see the contact in the list
    Examples:
      | role    |
      | manager |
      | agent   |
      | mdt     |

  @list
  Scenario Outline: Can view contacts that are assigned to my team
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to that role
    When I go to the contact list
    Then I can see the contact in the list
    Examples:
      | role                            |
      | manager                         |
      | agent                           |
      | mdt                             |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @list
  Scenario Outline: Certain roles can view contacts with needs that are assigned to a member of their team
    Given I am logged into the system as a "<role>" user
    And another user exists in that role
    And a support action is assigned to the other user
    When I go to the contact list
    Then I can see the contact in the list
    Examples:
      | role                            |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @list
  Scenario: MDT user cannot see contacts with needs assigned to another MDT user
    Given I am logged into the system as an "MDT" user
    And another user exists in that role
    And a support action for a contact is assigned to the other user
    When I go to the contact list
    Then I can not see that contact in the list

  @edit
  Scenario Outline: Roles that can edit a contact
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    When I go to the contact page for that contact
    Then I can see the option to edit the contact
    Examples:
      | role                            |
      | manager                         |
      | agent                           |
      | mdt                             |
      | council_service_name_of_service |

  @edit
  Scenario Outline: Roles that can not edit a contact
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    When I go to the contact page for that contact
    Then I cannot see the option to edit the contact
    Examples:
      | role                  |
      | food_delivery_manager |

  @edit
  Scenario Outline: Roles that can not see sensitive contact information
    Given I am logged into the system as a "<role>" user
    And a support action for a contact is assigned to me
    And the contact has sensitive information
    When I go to the contact page for that contact
    Then I cannot see that contact's sensitive information
    Examples:
      | role                  |
      | food_delivery_manager |

  @create
  Scenario Outline: Roles that can not create a contact
    Given I am logged into the system as a "<role>" user
    And I go to the contact list
    Then I cannot see the option to create a contact
    Examples:
      | role                  |
      | food_delivery_manager |