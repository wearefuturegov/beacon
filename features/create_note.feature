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
    And the note category is "<category>"
    Examples:
      | support_action                | category             | text                              |
      | Financial support             | Advice & Guidance    | Resident does not require help    |
      | Financial support             | Other                | Tried twice with no answer        |
      | Financial support             | Other                | Left the helpline number          |
      | Groceries and cooked meals    | Advice & Guidance    | Number not recognised             |
      | Physical and mental wellbeing | Other                | Resident requested weekly call    |
      | Financial support             | Other                | Resident concerned about the rent |
      | Staying social                | Other                | Resident joined online group      |
      | Prescription pickups          | Advice & Guidance    | Resident gets free prescriptions  |
      | Book drops and entertainment  | Other                | Would like some novels            |
      | Dog walking                   | Other                | Dog is lively                     |

  Scenario: Add a Advice with traveling to a Dog walking
    Given a resident with a "Dog walking" support action
    When I add a "Advice & Guidance" note "Resident confirmed required help"
    And I submit the form to create the note
    Then the list of notes contains "Resident confirmed required help"
    And the note category is "Advice & Guidance"
    And the time and date the note was created is present
    And the last note is at the top