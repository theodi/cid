@validate
Feature: Validate a datapackage

  Scenario: Package with a single CSV
    When I cd to "spec/fixtures/valid"
    And I run `cid validate`
    Then the output should contain "votes/votes-1.csv is VALID"

  Scenario: Package with multiple CSVs
    When I cd to "spec/fixtures/multiple_files"
    And I run `cid validate`
    Then the output should contain "votes/votes-1.csv is VALID"
    And the output should contain "votes/votes-2.csv is VALID"

  Scenario: Package with multiple folders
    When I cd to "spec/fixtures/multiple_folders"
    And I run `cid validate`
    Then the output should contain "seats/seats-1.csv is VALID"
    And the output should contain "seats/seats-2.csv is VALID"
    And the output should contain "votes/votes-1.csv is VALID"
    And the output should contain "votes/votes-2.csv is VALID"

  Scenario: Package with invalid CSV
    When I cd to "spec/fixtures/invalid"
    And I run `cid validate`
    Then the output should contain "votes/votes-1.csv is INVALID"

  Scenario: Specify directory
    When I run `cid validate spec/fixtures/valid`
    Then the output should contain "votes/votes-1.csv is VALID"

  Scenario: Path doesn't exist
    When I run `cid validate /this/is/fake`
    Then the output should contain "Path doesn't exist!"
    And the exit status should be 1
