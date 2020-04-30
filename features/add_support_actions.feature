@javascript
Feature: Add support actions
  As a Call centre agent
  I want to add multiples support actions to a person
  So that I can confirm details with people on the phone as their support actions are identified

  Call centre manager: 200 new shielded people have been added to the list from online referrals,
  I need to *see what my staff are currently working on*
  so I know who has capacity and then have a way to divide and assign the new cases to my staff

  Service manager: 50 new referrals have come through to the emergency food service,
  I need to *know who is a priority (e.g. need food today)*
  so I can prioritise assigning these cases to my team

  Call centre agent: I need to *know how I refer my calls or who I assign tasks to,
  e.g. Food service manager, ASC (not just people's names but their roles)*

  Call centre agent: As I'm confirming a residents details on the phone they
  begin telling me about whats going on in their life and I'm identifying some needs,
  I need to *easily be able to capture this without flicking back
  and forward between the tabs and having to save the page each time*

  Background:
    * I am logged into the system

  Scenario Outline: Add any support actions
    Given a resident
    When I add support actions "<support actions>"
    And I submit the add support actions form
    Then the residents list of support actions contains "<support actions>"
    Examples:
      | support actions               |
      | Groceries and cooked meals    |
      | Physical and mental wellbeing |
      | Financial support             |
      | Staying social                |
      | Prescription pickups          |
      | Book drops and entertainment  |
      | Dog walking                   |

  Scenario Outline: Add any support actions should not add assessment types
    Given a resident
    When I add support actions
    Then I should not be able to add "<assessment types>"
    Examples:
      | assessment types               |
      | Phone triage                  |
      | Check in                      |
      
  Scenario: Add multiple support actions
    Given a resident
    When I add support actions "Groceries and cooked meals"
    And I add another support action "Staying social"
    And I add another support action "Dog walking"
    And I submit the add support actions form
    Then the residents list of support actions contains "Groceries and cooked meals"
    And the residents list of support actions contains "Staying social"
    And the residents list of support actions contains "Dog walking"
