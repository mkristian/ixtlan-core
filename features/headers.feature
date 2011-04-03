Feature: Generators for Ixtlan Core

  Scenario: Create a rails application and adding the ixtlan-core adds ixtlan generators
    Given I create new rails application with template "headers.template" and "headers" tests
    Then the output should contain "7 tests, 18 assertions, 0 failures, 0 errors"
