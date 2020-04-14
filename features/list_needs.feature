Feature: List needs
  As a Call centre agent
  I want to list all needs in the system
  So that I can get a high level view of what needs exist

  Background:
    * I am logged into the system

  Scenario: View last contacted date
    Given a unique resident with a "Phone triage" need
    And I add a "Successful Call" note "Phone call text"
    And I submit the form to create the note
    When I view any needs list row for that resident
    Then I see the last contacted date is today