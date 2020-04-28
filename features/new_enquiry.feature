Feature: Create an inbound enquiry
  As a call centre agent
  I want to create an inbound enquiry
  so that I can add new persons in need of help to the system

  Background:
    * I am logged into the system

  Scenario: Add new enquiry
    Given an inbound enquiry
    When I add the enquiry details
    And I save the enquiry form
    Then I see a resident created message
    And the residents list of support actions contains "Initial review"
