@javascript
Feature: Fail an assessment
  As a phone agent
  I want to be guided through the assessment failure process
  So that I create the correct notes and status changes

  Background:
    * I am logged into the system
    * an assessment is assigned to me

  Scenario: An assessment is failed due to invalid contact information
    Given I am on the failed assessment page
    And I fail the assessment because 'Contact details were incorrect or missing'
    When I submit the failed assessment form
    Then the assessment is set to blocked
    And my note is stored against the assessment
    And the note says that the details are #Invalid

  Scenario: An assessment is failed due to the call not being answered
    Given I am on the failed assessment page
    And I fail the assessment because 'The call was not answered'
    When I submit the failed assessment form
    And my note is stored against the assessment
    And the note is of type 'Failed Call'