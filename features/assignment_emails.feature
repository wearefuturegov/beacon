Feature: Automated emails when support actions are assigned to users/roles
  As a user of the system
  I want to be notified via email when a support action is assigned to me
  So that I can be aware of what work I have in the system

  Background:
    * I am logged into the system

  @javascript
  Scenario: An email is sent when a user is assigned a support action
    Given a resident with a support action exists
    When I choose to notify with emails
    And I assign the support action to me
    Then I should receive an email notifying me of the assignment

  @javascript
  Scenario: An email is sent when a user is assigned a support action
    Given I am logged into the system as a "council_service_x" user
    And a resident with a support action exists
    When I choose to notify with emails
    And I assign the support action to the role "council_service_x role"
    Then I should receive an email notifying me of the assignment to my team
