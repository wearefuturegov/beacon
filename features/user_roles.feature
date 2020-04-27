Feature: Set user roles
  As an administrator
  I want to edit a user's roles
  so that I can determine what they can see and do in the system

  Scenario:
    When I am logged into the system as an admin
    Then I see the option to view the list of users

  @javascript
  Scenario:
    Given I am logged into the system as an admin
    And I am viewing the users list
    When I select a user
    Then I can see the edit users page

  Scenario:
    Given I am logged into the system as an admin
    And another role "other role" exists
    And I am editing my user profile
    And I select that I am in the "other role" role
    When I save my changes
    Then I see that my roles have been updated
    And I see the option to switch between my roles