Feature: Search person
  As a call centre agent
  I want to be able to search for a person
  so that I can access the profile of the person on the phone if the person is found
  and have the option to create a new entry in the system if the person is not found

  Background:
    * I am logged into the system

  Scenario: The named person searched for exists in the system
    Given a resident
    When I search for the resident by name
    Then I see the residents details

  Scenario: Search by dob

  Scenario: search by NHS number

  Scenario: The named person searched for does not exist in the system
    Given a name of "NoNameMatch"
    When I search by name "NoNameMatch"
    Then I see an error message "No match"

  Scenario: More than one person matches the search
    Given 5 residents called "Jones"
    When I search by name "Jones"
    Then I see several matched responses