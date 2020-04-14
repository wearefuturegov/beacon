Feature: Edit needs
  As a user of the system
  I want to edit a persons need
  So that I can assign a user, and change the key details

  Background:
    * I am logged into the system

  @javascript
  Scenario: Assign myself a need
    Given a resident with a need exists
    When I assign the need to me
    Then I see the need in the 'assigned to me' page
    And I see the updated need details in the contact's 'needs' list

  @javascript
  Scenario: Reassign a need from myself to another user
    Given a resident with a need exists
    And I have assigned the need to me
    When I assign the need to another user
    Then I no longer see the need in the 'assigned to me' page
    And I see the updated need details in the contact's 'needs' list

  @javascript
  Scenario:
    Given a resident with a need exists
    And I have assigned the need to me
    And the need has status 'to do'
    When I change the need status to 'complete'
    Then I see the updated need details in the contact's 'completed' list