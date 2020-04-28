Feature: On call with resident
  As a call centre agent
  I want to edit a residents profile and needs in a single view
  so that I can update the residents details and add needs at the same time

  Call centre agent: As I'm confirming a residents details on the phone they
  begin telling me about whats going on in their life and I'm identifying some needs,
  I need to *easily be able to capture this without flicking back
  and forward between the tabs and having to save the page each time*

  Background:
    * I am logged into the system

  Scenario: Answer yes to free prescriptions
    Given I am on a call with a resident
    And I am conducting a triage of the residents needs
    When I choose "Yes" to eligible for free prescriptions
    And I save the edit resident form
    Then I see a resident updated message
    And eligible for free prescriptions is "Yes"

  Scenario: Answer no to free prescriptions
    Given I am on a call with a resident
    And I am conducting a triage of the residents needs
    When I choose "No" to eligible for free prescriptions
    And I save the edit resident form
    Then I see a resident updated message
    And eligible for free prescriptions is "No"

  Scenario: Special dietary requirements no cooking facilities
    Given I am on a call with a resident
    And I am conducting a triage of the residents needs
    When I choose "Yes" to any dietary requirements
    And I edit the dietary details to "Vegan"
    And I save the edit resident form
    Then I see a resident updated message
    And the dietary requirements is "Yes"
    And the dietary details is "Vegan"

  @javascript
  Scenario: Save for later - new enquiry
    Given I am on a call with a resident
    And I am conducting a triage of the residents needs
    When I start a new enquiry
    And I choose to save the triage for later
    Then I see a triage saved for draft message
    And the new enquiry form is displayed to me

  @javascript
  Scenario: Save for later - stay on the page
    Given I am on a call with a resident
    And I am conducting a triage of the residents needs
    When I start a new enquiry
    But I choose to stay on the page
    Then I can still see the triage form
  
  @javascript
  Scenario: Save for later - return to triage
    Given I have a draft triage pending completion
    When I return to the triage
    Then I see the triage draft values again
