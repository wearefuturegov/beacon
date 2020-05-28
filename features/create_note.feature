@javascript
Feature: Create note
  As a Call centre agent
  I want to add notes and call logs to a residents needs
  So that I can record details of the interactions with the resident

  Background:
    * I am logged into the system

  Scenario Outline: Add a note to a support action
    Given a resident with a "<support_action>" support action
    When I add a "<category>" note "<text>"
    And I submit the form to create the note
    Then the list of notes contains "<text>"
    And the note category is "category"
    Examples:
      | support_action                | category        | text                              |
      | Financial support             | Successful Call | Resident does not require help    |
      | Financial support             | Failed Call     | Tried twice with no answer        |
      | Financial support             | Left Message    | Left the helpline number          |
      | Groceries and cooked meals    | Failed Call     | Number not recognised             |
      | Physical and mental wellbeing | Note            | Resident requested weekly call    |
      | Financial support             | Successful Call | Resident concerned about the rent |
      | Staying social                | Note            | Resident joined online group      |
      | Prescription pickups          | Note            | Resident gets free prescriptions  |
      | Book drops and entertainment  | Successful Call | Would like some novels            |
      | Dog walking                   | Note            | Dog is lively                     |

  Scenario: Add a Successful call to a Dog walking
    Given a resident with a "Dog walking" support action
    When I add a "Successful Call" note "Resident confirmed required help"
    And I submit the form to create the note
    Then the list of notes contains "Resident confirmed required help"
    And the note category is "Successful Call"
    And the last note is at the top

  Scenario: Add a Successful call to a Dog walking with a blank note
    Given a resident with a "Dog walking" support action
    When I add a "Successful Call" note "Call details"
    And I submit the form to create the note
    Then the list of notes contains "Call details"
    And the note category is "Successful Call"