Feature: Generators for Ixtlan Core

  Scenario: Create a rails application and adding the ixtlan-core adds ixtlan generators
    Given I create new rails application with template "simple.template"
    Then the output should contain "ixtlan:setup" and "ixtlan:configuration_model" and "ixtlan:configuration_scaffold"
