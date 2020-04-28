Feature: Edit support actions
  As a user of the system
  I want to edit a persons support action
  So that I can assign a user, and change the key details

  Background:
    * I am logged into the system

  @javascript
  Scenario: Assign myself a support action
    Given a resident with a support action exists
    When I assign the support action to me
    Then I see the support action in the 'assigned to me' page
    And I see the updated support action details in the contact's 'support actions' list

  @javascript
  Scenario: Reassign a support action from myself to another user
    Given a resident with a support action exists
    And I have assigned the support action to me
    When I assign the support action to another user
    Then I no longer see the support action in the 'assigned to me' page
    And I see the updated support action details in the contact's 'support actions' list

  @javascript
  Scenario:
    Given a resident with a support action exists
    And I have assigned the support action to me
    And the support action has status 'to do'
    When I change the support action status to 'complete'
    Then I see the updated support action details in the contact's 'completed' list