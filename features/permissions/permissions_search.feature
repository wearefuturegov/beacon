@permissions @support_actions
Feature: Restrict viewing/editing search results to a user based on their role
  As a beacon owner
  I want to restrict what contacts people can search for in beacon
  so that data is kept secure

  @search
  Scenario Outline: Search results restricted to contacts assigned to me
    Given I am logged into the system as a "<role>" user
    And a support action for contact "Bob" is assigned to me
    And another contact "Bobby" is not visible to me
    And I go to the contact list
    When I search for the resident by "Bob"
    Then I can see the permitted contact in the list
    And I can not see the non-visible contact in the list
    Examples:
      | role                            |
      | mdt                             |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @search
  Scenario Outline: Search results restricted to contacts assigned to my team members
    Given I am logged into the system as a "<role>" user
    And another user exists in that role
    And a support action for contact "Bob" is assigned to the other user
    And another contact "Bobby" is not visible to me
    And I go to the contact list
    When I search for the resident by "Bob"
    Then I can see the permitted contact in the list
    And I can not see the non-visible contact in the list
    Examples:
      | role                            |
      | food_delivery_manager           |
      | council_service_name_of_service |

  @search
  Scenario Outline: Search results restricted to contacts assigned to my team members
    Given I am logged into the system as a "<role>" user
    And a support action for contact "Bob" is assigned to that role
    And another contact "Bobby" is not visible to me
    And I go to the contact list
    When I search for the resident by "Bob"
    Then I can see the permitted contact in the list
    And I can not see the non-visible contact in the list
    Examples:
      | role                            |
      | food_delivery_manager           |
      | council_service_name_of_service |