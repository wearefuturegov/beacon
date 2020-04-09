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

  Scenario: Update total number of people in the household
    Given I am on a call with a resident
    And I am editing the residents profile
    When I edit the total number of people to "57"
    And I save the edit resident form
    Then I see a resident updated message
    And the total number of people is "57"

  Scenario: Enter residents special delivery needs
    Given I am on a call with a resident
    And I am editing the residents profile
    When I edit the special delivery details "flats - need to buzz"
    And I save the edit resident form
    Then I see a resident updated message
    And the special delivery details are "flats - need to buzz"

  Scenario: Answer yes to any children under 15
    Given I am on a call with a resident
    And I am editing the residents profile
    When I choose "Yes" for any children under 15
    And I save the edit resident form
    Then I see a resident updated message
    And the children under 15 details are "Yes"

  Scenario: Answer no to any children under 15
    Given I am on a call with a resident
    And I am editing the residents profile
    When I choose "No" for any children under 15
    And I save the edit resident form
    Then I see a resident updated message
    And the children under 15 details are "No"

  Scenario: Answer yes to free prescriptions
    Given I am on a call with a resident
    And I am editing the residents profile
    When I choose "Yes" to eligible for free prescriptions
    And I save the edit resident form
    Then I see a resident updated message
    And eligible for free prescriptions is "Yes"

  Scenario: Answer no to free prescriptions
    Given I am on a call with a resident
    And I am editing the residents profile
    When I choose "No" to eligible for free prescriptions
    And I save the edit resident form
    Then I see a resident updated message
    And eligible for free prescriptions is "No"

  Scenario: Special dietary requirements no cooking facilities
    Given I am on a call with a resident
    And I am editing the residents profile
    When I choose "Yes" to any dietary requirements
    And I edit the dietary details to "Vegan"
    And I save the edit resident form
    Then I see a resident updated message
    And the dietary requirements is "Yes"
    And the dietary details is "Vegan"


  Scenario: Special dietary requirements Microwave
  Scenario: Special dietary requirements Hob and Oven
  Scenario: Person has no food today
  Scenario: Person has a allergy
  Scenario: Person has a cat
  Scenario: Person lives on 4th floor of building and cannot use the stairs.
  Scenario: Person has enough food for the next couple of days but has an underlying health condition
  and is feeling very distressed.
  They are unable to work at this time and are unsure how they will pay the rent this month.
  Scenario: Person has food but is anxious about how their medicine will be collected / how they will get to a medical appointment
  Scenario: Person does not have food and needs specialist food due to their medical condition (eg cancer treatment),
  religion/culture eg halal/vegan
  Scenario: Person is concerned about someone they know who is at risk – how they can get help
  Scenario: Person has food but needs support taking waste out of their property
