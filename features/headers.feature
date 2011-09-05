Feature: Generators for Ixtlan Core

  Scenario: Create a rails application and adding the ixtlan-core adds ixtlan generators
    Given I create new rails application with template "headers.template" and "headers" tests
    And I execute "rails generate scaffold user name:string --skip --migration"
    And I execute "rake db:migrate test"
    Then the output should contain "7 tests, 20 assertions, 0 failures, 0 errors" and "1 tests, 1 assertions, 0 failures, 0 errors"

    Given me an existing rails application "headers" and "optimistic" tests
    And I execute "rails generate scaffold account name:string --skip --migration --timestamps --optimistic"
    And I execute "rake db:migrate test"
    Then the output should contain "14 tests, 30 assertions, 0 failures, 0 errors" and "2 tests, 2 assertions, 0 failures, 0 errors"
