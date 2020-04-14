Feature: Add needs
  As a user of the system
  I want to edit a persons need
  So that I can assign a user, and change the key details

  Background:
    * I am logged into the system

  Scenario: Assign myself a need
    Given a resident with a need exists
    And I am viewing the need
    When I assign the need to me
    Then I see the need in the 'assigned to me' page
    And I see the updated need details in the contact's 'needs' list
#
#  Scenario: Reassign a need from myself to another user
#    Given a resident with a need exists
#    And I am viewing the need
#    And the need is assigned to me
#    When I assign the need to another user
#    Then I no longer see the need in the 'assigned to me' page
#    And I see the updated need details in the contact's needs list
#
#  Scenario:
#    Given a resident with a need exists
#    And I am viewing the need
#    And the need has status 'to do'
#    When I change the need status to 'complete'
#    Then I see the updated need details in the contact's needs list