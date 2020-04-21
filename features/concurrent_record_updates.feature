Feature: Edit records concurrently
  As a user of the system
  I want to be informed when other users access or change the same data I am working on
  So that the information I key-in can be stored correctly

  Background:
    * I am logged into the system as an admin
    * Someone else is logged into the system

  @javascript
  Scenario: Update a need concurrently
    Given a resident with a need exists
    And I have assigned the need to me
    And the need has status 'to do'
    When I change someone else's need status to 'complete'
    Then I see my need change was unsuccessful

  @javascript
  Scenario: Update resident name concurrently
    Given a resident
    When I change someone else's residents record
    Then I see my resident change was unsuccessful