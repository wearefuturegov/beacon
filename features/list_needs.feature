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

  @javascript
  Scenario: Filter resident needs by category
    Given a unique resident with a "Groceries and cooked meals" need
    When I view any needs list row for that resident
    And I filter needs by category "Groceries and cooked meals"
    Then I see the need for category "Groceries and cooked meals" in the results

  @javascript
  Scenario Outline: Filter all needs by category
    Given many needs exist
    When I filter needs by category "<category>"
    Then I see all needs for the category "<category>" in the results
    Examples:
      | category                      |
      | Phone triage                  |
      | Groceries and cooked meals    |
      | Financial support             |
      | Dog walking                   |     