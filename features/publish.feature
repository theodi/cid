@publish
Feature: Publish a datapackage

  Scenario: Create datapackage
    Given I run `cp -r ../../spec/fixtures/valid valid`
    And I cd to "valid"
    When I run `cid publish`
    Then the output should contain "Datapackage created"
    And I run `cat datapackage.json`
    Then the output should contain "votes/votes-1.csv"

  Scenario: Create datapackage with new files
    Given I run `cp -r ../../spec/fixtures/multiple_files multiple_files`
    And I cd to "multiple_files"
    When I run `cid publish`
    Then the output should contain "Datapackage created"
    And I run `cat datapackage.json`
    Then the output should contain "votes/votes-1.csv"
    And the output should contain "votes/votes-2.csv"

  Scenario: Return error if not in a git repo
    Given I run `cp -r ../../spec/fixtures/multiple_files multiple_files`
    And I cd to "multiple_files"
    When I run `cid publish`
    Then the output should contain "Git repo not found"
    And the exit status should be 1

  Scenario: Sucessfully push to Github
    Given I run `git clone https://github.com/theodi/cid-test.git`
    And I cd to "cid-test"
    When I successfully run `cid publish`
    Then the output should contain "Changes pushed successfully"

  Scenario: Path doesn't exist
    When I run `cid publish /this/is/fake`
    Then the output should contain "Path doesn't exist!"
    And the exit status should be 1

  Scenario: Github token not specified
    Given I set the environment variables to:
      | variable           | value      |
      | GITHUB_OAUTH_TOKEN |            |
    When I run `cid publish`
    Then the output should contain "Github token not specified"
    And the exit status should be 1

  Scenario: Failed Github push
    Given I run `git clone https://github.com/pezholio/cid-test.git`
    And I cd to "cid-test"
    When I run `cid publish`
    Then the output should contain "Github authorisation error"
    And the exit status should be 1

  Scenario: Skip GitHub
    Given I run `cp -r ../../spec/fixtures/multiple_files multiple_files`
    And I cd to "multiple_files"
    When I run `cid publish --skip-github`
    Then the output should contain "Datapackage created"
    And the output should not contain "Git repo not found"
    And the exit status should be 0
