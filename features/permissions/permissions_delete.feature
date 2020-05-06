@permissions @support_actions @javascript
Feature: Restrict deletion of support actions and notes to a user based on their role
  As a beacon owner
  I want to restrict what record people can delete in beacon
  so that data is kept secure

  Scenario Outline: Anyone can delete a need they have created without notes
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
      | mdt     |