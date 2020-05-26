Feature: Invite user
  As a system administrator
  I want to be able to invite users and admin users to use the system
  so that the people who need to access the system are able to do so.

  Background:
    * I am logged into the system as a 'sysadmin' user

  Scenario: Add a user
    Given a users email address "normaluser@test.com"
    When I enter the email address into the user form
    And I send the invite
    Then I see a user created message
    And the email address is in the list of users

  Scenario: Add a duplicate user
  email addresses must be unique the test email is
  used to login to run the tests so is a duplicate
    Given a user exists with the email "test@test.com"
    And a users email address "test@test.com"
    When I enter the email address into the user form
    And I send the invite
    Then I see an error message about the email
