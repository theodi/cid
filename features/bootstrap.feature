@bootstrap @inprocess
Feature: Bootstrap .travis.yml file

  Scenario: Create a .travis.yml file
    Given I run `cp -r ../../spec/fixtures/valid valid`
    And I cd to "valid"
    When I run `cid bootstrap`
    And I run `cat .travis.yml`
    Then the output should contain:
      """
      ---
      before_script: gem install cid
      script: cid validate
      after_success: '[ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && cid publish'

      """

  Scenario: Specify different branch
    Given I run `cp -r ../../spec/fixtures/valid valid`
    And I cd to "valid"
    When I run `cid bootstrap --branch=gh-pages`
    And I run `cat .travis.yml`
    Then the output should contain "gh-pages"

  @skip-ci
  Scenario: Create a .travis.yml file with a Github token
    Given I run `git clone https://github.com/theodi/cid-test.git`
    And I cd to "cid-test"
    And I run `rm .travis.yml`
    When I run `cid bootstrap --github-token=foobarbaz`
    Then the output should not contain "Can't figure out GitHub repo name."
    And I run `cat .travis.yml`
    Then the output should contain "secure:"

  @skip-ci
  Scenario: Not in a repo with a Github remote
    Given I run `mkdir no-remote && cd no-remote`
    And I set up a new git repo
    And I run `cid bootstrap --github-token=foobarbaz`
    Then the output should contain "Can't figure out GitHub repo name."
    And I run `cat .travis.yml`
    Then the output should not contain "secure:"
