Feature: Search user
  As an admin
  I want to be able to search for a user
  so that I can access the profile of the user if the user is found
  
  Background:
    * I am logged into the system as an admin
    
  Scenario: The first named user searched for exists in the system
    Given a user exists with the email "user1@test.com"
    When I search for the user by "John"
    Then I see the user in the search results
    
  Scenario: Search user by last name
    Given a user exists with the email "user1@test.com"
    When I search for the user by "Doe"
    Then I see the user in the search results

  Scenario: Search user by full name
    Given a user exists with the email "user1@test.com"
    When I search for the user by "John Doe"
    Then I see the user in the search results
      
  Scenario: Search user by email
    Given a user exists with the email "user1@test.com"
    When I search for the user by "user1"
    Then I see the user in the search results
    