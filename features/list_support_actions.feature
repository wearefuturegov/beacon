Feature: List needs
  As a Call centre agent
  I want to list all needs in the system
  So that I can get a high level view of what needs exist

  Background:
    * I am logged into the system

  Scenario: View last contacted date
    Given a unique resident
    When I add needs "Dog walking"
    And I submit the add needs form
    And I add a "Successful Call" note "Phone call text"
    And I submit the form to create the note
    When I view any needs list row for that resident
    Then I see the last contacted date is today

  @javascript
  Scenario Outline: Filter resident needs by category
    Given a resident with a "<category>" support action
    When I view any needs list row for that resident
    And I filter needs by category "<category>"
    Then I see the support action for category "<category>" in the results
    Examples:
      | category    |
      | Dog walking |

  @javascript
  Scenario Outline: Filter all needs by category
    Given many needs exist
    When I filter needs by category "<category>"
    Then I see every needs with category "<category>" in the results
    Examples:
      | category                   |
      | Groceries and cooked meals |
      | Financial support          |
      | Dog walking                |


  Scenario: Sort needs by category ascending
    Given a resident with "Book drops and entertainment, Dog walking, Groceries and cooked meals" needs
    When I sort needs by category in "ASC" order
    Then I see the support action for category "Book drops and entertainment" first in the results

  Scenario: Sort needs by category descending
    Given a resident with "Book drops and entertainment, Dog walking, Groceries and cooked meals" needs
    When I sort needs by category in "DESC" order
    Then I see the support action for category "Groceries and cooked meals" first in the results

  Scenario: See unassigned needs I have created in the created and unassigned list
    Given I have created a support action "Dog walking"
    When I go the the created and unassigned support action list
    Then I see the support action for category "Dog walking" in the results

  @javascript
  Scenario: Do not see assigned needs I have created in the created and unassigned list
    Given I have created a support action "Dog walking"
    And I assign the support action to another user
    When I go the the created and unassigned support action list
    Then I can not see that support action in the list