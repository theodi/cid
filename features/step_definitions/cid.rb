Given(/^I set up a new git repo$/) do
  steps %{
    And I run `git init`
    And I run `git add .`
    And I run `git commit -am 'New git repo'`
  }
end
