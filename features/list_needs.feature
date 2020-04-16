Feature: List needs
  As a Call centre agent
  I want to list all needs in the system
  So that I can get a high level view of what needs exist

  Background:
    * I am logged into the system

  Scenario: View last contacted date
    Given a unique resident
    When I add needs "Phone triage"
    And I set the start date for the "Phone triage" need to "1/1/2020"
    And I submit the add needs form
    And I add a "Successful Call" note "Phone call text"
    And I submit the form to create the note
    When I view any needs list row for that resident
    Then I see the last contacted date is today

  @javascript
  Scenario Outline: Filter resident needs by category
    Given a resident with a "<category>" need
    When I view any needs list row for that resident
    And I filter needs by category "<category>"
    Then I see the need for category "<category>" in the results
    Examples:
      | category                      |
      | Dog walking                   |

  @javascript
  Scenario Outline: Filter all needs by category
    Given many needs exist
    When I filter needs by category "<category>"
    Then I see every needs with category "<category>" in the results
    Examples:
      | category                      |
      | Groceries and cooked meals    |
      | Financial support             |
      | Dog walking                   |


    Scenario: Sort needs by category ascending
      Given a resident with a "Book drops and entertainment" need
      And a resident with a "Groceries and cooked meals" need
      When I sort needs by category in "ASC" order
      Then I see the need for category "Book drops and entertainment" first in the results

    Scenario: Sort needs by category descending
      Given a resident with a "Book drops and entertainment" need
      And a resident with a "Groceries and cooked meals" need
      When I sort needs by category in "DESC" order
      Then I see the need for category "Groceries and cooked meals" first in the results