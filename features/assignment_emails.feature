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
  
  @javascript
  Scenario: Complete assessment when email notification
    Given I am logged into the system as a "council_service_x" user
    And the mdt role exists
    And an assessment is assigned to me
    And I have chosen to notify with emails
    And I have assigned needs "Groceries and cooked meals" to "council_service_x role" for the assessment    
    When I complete the assessment with the required fields
    Then I should receive an email notifying me of the assignment to my team