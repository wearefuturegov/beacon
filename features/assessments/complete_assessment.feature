Feature: Complete an assessment
  As a phone agent
  I want to be guided through the assessment completion process
  So that I create the correct needs, notes and status changes

  Background:
    * I am logged into the system
    * the mdt role exists
    * an assessment is assigned to me

  Scenario: Complete assessment when no check in exists
    Given I have assigned needs "Groceries and cooked meals" to "Unassigned" for the assessment
    And I am on the assessment completion page
    Then I should be informed there are no scheduled further check ins

  Scenario: Complete assessment when a future check in exists
    Given the contact for the assessment has a scheduled check in
    And I have assigned needs "Groceries and cooked meals" to "Unassigned" for the assessment
    And I am on the assessment completion page
    Then I should see the date of the next check in

  Scenario: Schedule a future check in
    Given I have assigned needs "Groceries and cooked meals" to "Unassigned" for the assessment
    And I am on the assessment completion page
    And I schedule a check in for tomorrow
    And I fill in the required fields
    When I complete the assessment
    And I go to the contact page for that contact
    Then I should see the future check in

  Scenario: Be prompted to create an MDT review
    Given the contact for the assessment has a scheduled check in
    Given I have assigned needs "Groceries and cooked meals" to "MDT team" for the assessment
    And I am on the assessment completion page
    And I create an MDT review
    And I fill in the required fields
    When I complete the assessment
    And I go to the contact page for that contact
    Then I should see the MDT review
  
  Scenario: Cannot Start a completed assessment
    Given I have completed an assessment
    When I choose to see the assessment
    Then I can see the assessment has a completed status
    And I cannot see the option to start the assessment
