Feature: Add assessment
  As a Call centre agent/manager
  I want to log and schedule assessments for a contact
  So that I can capture details of communications with a contact

  Background:
    * I am logged into the system

  Scenario: Navigate to the 'schedule an assessment' form
    Given a resident
    And I am on their profile page
    When I choose to schedule an assessment
    Then I see the schedule assessment form

  Scenario: Navigate to the 'log an assessment' form
    Given a resident
    And I am on their profile page
    When I choose to log an assessment
    Then I see the log assessment form

  Scenario: Successfully schedule an assessment
    Given a resident
    And I am on their profile page
    And I choose to schedule an assessment
    And I enter valid details
    When I save the assessment
    Then I see the saved assessment details on the contact

  @javascript
  Scenario: Successfully log an assessment
    Given a resident
    And I am on their profile page
    And I choose to log an assessment
    And I enter valid details
    When I save the assessment
    Then I see the saved assessment details on the contact
