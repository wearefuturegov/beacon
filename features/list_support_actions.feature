Feature: List support actions
  As a Call centre agent
  I want to list all support actions in the system
  So that I can get a high level view of what support actions exist

  Background:
    * I am logged into the system

  Scenario: View last contacted date
    Given a unique resident
    When I add support actions "Dog walking"
    And I submit the add support actions form
    And I add a "Successful Call" note "Phone call text"
    And I submit the form to create the note
    When I view any support actions list row for that resident
    Then I see the last contacted date is today
    Then I see one call attempt

  @javascript
  Scenario Outline: Filter resident support actions by category
    Given a resident with a "<category>" support action
    When I view any support actions list row for that resident
    And I filter support actions by category "<category>"
    Then I see the support action for category "<category>" in the results
    Examples:
      | category    |
      | Dog walking |

  @javascript
  Scenario Outline: Filter all support actions by category
    Given many support actions exist
    When I filter support actions by category "<category>"
    Then I see every support actions with category "<category>" in the results
    Examples:
      | category                   |
      | Groceries and cooked meals |
      | Financial support          |
      | Dog walking                |


  Scenario: Sort support actions by category ascending
    Given a resident with "Book drops and entertainment, Dog walking, Groceries and cooked meals" support actions
    When I sort support actions by category in "ASC" order
    Then I see the support action for category "Book drops and entertainment" first in the results

  Scenario: Sort support actions by category descending
    Given a resident with "Book drops and entertainment, Dog walking, Groceries and cooked meals" support actions
    When I sort support actions by category in "DESC" order
    Then I see the support action for category "Groceries and cooked meals" first in the results

  Scenario: See unassigned needs I have created in the created and unassigned list
    Given a unique resident
    And I add support actions "Dog walking"
    And I submit the add support actions form
    When I go the the created and unassigned support action list
    Then I see the support action for category "Dog walking" in the results

  @javascript
  Scenario: Do not see assigned needs I have created in the created and unassigned list
    Given a unique resident
    And I add support actions "Dog walking"
    And I submit the add support actions form
    And I assign the support action to another user
    When I go the the created and unassigned support action list
    Then I can not see that support action in the list