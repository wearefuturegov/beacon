Feature: Search person
  As a call centre agent
  I want to be able to search for a person
  so that I can access the profile of the person on the phone if the person is found
  and have the option to create a new entry in the system if the person is not found

  Background:
    * I am logged into the system

  Scenario: The named person searched for exists in the system
    Given a resident with a complete profile
    When I search for the resident by "Forename"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: Search by Year of Birth
    Given a resident with a complete profile
    When I search for the resident by "1982"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: search by NHS number
    Given a resident with a complete profile
    When I search for the resident by "NHS-999999"
    Then I see the resident in the search results
    And I see an option to add a person

  Scenario: The named person searched for does not exist in the system
    Given a resident with a complete profile
    When I search for the resident by "Thisdoesnotexist"
    Then I see a "No matches" message
    And I see an option to add a person
