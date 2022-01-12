Feature: Search person
  As a call centre agent
  I want to be able to search for a person
  so that I can access the profile of the person on the phone if the person is found
  and have the option to create a new entry in the system if the person is not found

  Background:
    * I am logged into the system

  Scenario: The named person searched for exists in the system by first name
    Given a resident with a complete profile
    When I search for the resident by part of the "first name" "renam"
    Then I see the resident in the search results
    And I see an option to add a person
    
  Scenario: The named person searched for exists in the system by middle name
    Given a resident with a complete profile
    When I search for the resident by part of the "middle name" "ddlenam"
    Then I see the resident in the search results
    And I see an option to add a person
    
  Scenario: The named person searched for exists in the system by surname
    Given a resident with a complete profile
    When I search for the resident by part of the "surname" "urna"
    Then I see the resident in the search results
    And I see an option to add a person
    
  Scenario: Search by postcode with whitespace
    Given a resident with a complete profile
    When I search for the resident by part of the "Postcode" "B12 9"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: Search by postcode with No whitespace
    Given a resident with a complete profile
    When I search for the resident by part of the "Postcode" "B129"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: Search by postcode in lowercase
    Given a resident with a complete profile
    When I search for the resident by part of the "Postcode" "b129"
    Then I see the resident in the search results
    And I see an option to add a person    

  Scenario: Search by Year of Birth
    Given a resident with a complete profile
    When I search for the resident by part of the "Year of Birth" "1982"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: search by NHS number
    Given a resident with a complete profile
    When I search for the resident by part of the "NHS number" "NHS-999999"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: The named person searched for does not exist in the system
    Given a resident with a complete profile
    When I search for the resident by part of the "any field" "Thisdoesnotexist"
    Then I see a "No matches" message
    And I see an option to add a person
