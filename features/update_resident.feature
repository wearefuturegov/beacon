@javascript
Feature: Update person
  As a call centre agent
  I want to edit a residents profile
  so that I can update the residents details

  Call centre agent: As I'm confirming a residents details on the phone they
  begin telling me about whats going on in their life and I'm identifying some needs,
  I need to *easily be able to capture this without flicking back
  and forward between the tabs and having to save the page each time*

  Background:
    * I am logged into the system

  Scenario: Update names
    Given a resident
    When I edit the residents name
    And I save the edit resident form
    Then I see a resident updated message
    And the residents names have been updated

  Scenario: Person does not answer the phone on attempt 1/2/3
  The feature here is a requirement to capture notes against the person
  or complete the additional information field
    Given a resident
    When I edit the residents additional info
    And I save the edit resident form
    Then I see a resident updated message
#    And the residents additional info has been updated

  Scenario: Resident has moved and lives at a new address
    Given a resident
    When I edit the residents address
    And I save the edit resident form
    Then I see a resident updated message
    And the residents address has been updated

  Scenario: Update how to reach them
    Given a resident
    When I edit the residents contact details
    And I save the edit resident form
    Then I see a resident updated message
    And the residents contact details have been updated

  Scenario: Update vulnerability
    Given a resident
    When I edit the residents vulnerability status
    And I save the edit resident form
    Then I see a resident updated message
    And the residents vulnerability status has been updated

  Scenario: Update has covid-19
    Given a resident
    When I edit the residents covid-19 status
    And I save the edit resident form
    Then I see a resident updated message
    And the residents covid-19 status has been updated
