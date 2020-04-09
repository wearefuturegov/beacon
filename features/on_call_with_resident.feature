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

  Scenario: Resident has special delivery needs
    Given I am on a call with a resident
    And I am editing the residents profile
    When I edit the total number of people to "5"
    And I save the edit resident form
    Then I see a resident updated message
    And the total number people is "5"

  Scenario: Resident has special delivery needs
    Given I am on a call with a resident
    And I am editing the residents profile
    When I edit the special delivery details "flats - need to buzz"
    And I save the edit resident form
    Then I see a resident updated message
    And the special delivery details are "flats - need to buzz"


  Scenario: Household with children under 15

  Scenario: Special dietary requirements no cooking facilities
  Scenario: Special dietary requirements Microwave
  Scenario: Special dietary requirements Hob and Oven

#  Scenario Outline: Groceries and cooked meals
#    Given I am on a call with a resident
#    And I am editing the residents profile
#    When I add needs "Groceries and cooked meals"
#    And I choose "Yes" to any dietary requirements
#    And I enter dietary details of "Vegan"
#    And I enter cooking facilities of "Microwave"
#    And I save the edit resident form
#
#  Scenario: Person has no food today
#    Given I am on a call with a resident
#    And I am editing the residents profile
#    When I edit the residents name
#    And I save the edit resident form
#    Then I see a resident updated message
#    And the residents names have been updated

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
    And the residents additional info has been updated

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
