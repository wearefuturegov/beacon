@permissions @support_actions
Feature: Restrict deletion of support actions and notes to a user based on their role
  As a beacon owner
  I want to restrict what record people can delete in beacon
  so that data is kept secure

  @javascript
  Scenario Outline: Anyone can delete a support action they have created without notes
    Given I am logged into the system as a "<role>" user
    And a resident with 'Dog walking' support actions
    And no notes exists on the support actions
    When I edit the support action
    Then I can delete the support action
    And I can see a deletion confirmation message
    Examples:
      | role    |
      | manager |
      | agent   |

  Scenario Outline: Users cannot delete a support action they have not created
    Given I am logged into the system as an admin
    And a support action for contact "Luka Edge" is assigned to role "<role>"
    And I logged out
    And I am logged into the system as a "<role>" user
    When I edit the support action
    Then I cannot delete the support action
    Examples:
      | role  |
      | mdt   |
      | agent |

  @javascript
  Scenario: Managers can delete a support action they have not created
    And I am logged into the system as a "food_delivery_manager" user
    And a support action for contact "George Ball" is assigned to role "<role>"
    And I logged out
    And I am logged into the system as a "manager" user
    When I edit the support action
    Then I can delete the support action
    And I can see a deletion confirmation message


  @javascript
  Scenario Outline: Anyone can delete a support action they have created without notes
    Given I am logged into the system as a "<role>" user
    And a resident with 'Dog walking' support actions
    And I added a "Note" note "asdfg"
    When I edit the support action
    Then I can delete the support action
    And I can see a deletion confirmation message
    Examples:
      | role    |
      | manager |
      | agent   |

  Scenario Outline: Anyone can delete a support action they have created with own notes
  Scenario Outline: Users cannot delete a support action they have created with notes they have not created
  Scenario Outline: Anyone can delete own notes
  Scenario Outline: Users cannot delete notes they have not created
  Scenario Outline: Managers can delete notes they have not created