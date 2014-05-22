@publish
Feature: Publish a datapackage

  Scenario: Create datapackage
    Given I run `cp -r ../../spec/fixtures/valid valid`
    And I cd to "valid"
    When I run `cid publish`
    And I run `cat datapackage.json`
    Then the output should contain "votes/votes-1.csv"

  Scenario: Create datapackage with new files
    Given I run `cp -r ../../spec/fixtures/multiple_files multiple_files`
    And I cd to "multiple_files"
    When I run `cid publish`
    And I run `cat datapackage.json`
    Then the output should contain "votes/votes-1.csv"
    And the output should contain "votes/votes-2.csv"
