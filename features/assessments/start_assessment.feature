Feature: Start an assessment
  As a phone agent
  I want to be asked whether I have start an assessment successfully
  So that I can be guided through the assessment process

  Background:
    * I am logged into the system
    * an assessment is assigned to me

  Scenario: See the assessment start button from the details page
    When I go to the assessment details page
    Then I see the option to start the assessment

  Scenario: See the assessment start button from the list view
    When I go to the needs list
    Then I see the option to start the assessment

  Scenario: Start an assessment and see options
    Given I go to the assessment details page
    And I choose to start the assessment
    And I see the assessment opening questionnaire
    When I choose to continue the assessment
    Then I see the assessment triage page

