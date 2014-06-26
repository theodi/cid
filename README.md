[![Build Status](https://travis-ci.org/theodi/cid.svg)](https://travis-ci.org/theodi/cid)
[![Coverage Status](http://img.shields.io/coveralls/theodi/cid.svg)](https://coveralls.io/r/theodi/cid)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/cid.svg)](https://codeclimate.com/github/theodi/cid)
[![Gem Version](http://img.shields.io/gem/v/cid.svg)](https://rubygems.org/gems/cid)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://theodi.mit-license.org)
[![Badges](http://img.shields.io/:badges-6/6-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

# Cid

Cid is **C**ontinuous **I**ntegraton for **D**ata.

There are two facets to Cid:

The first takes a [Datapackage](http://dataprotocols.org/data-packages/) with CSVs
in a Github repo and validates each one against a schema (in [JSON table schema](http://dataprotocols.org/json-table-schema/) format) which lives in the same folder.

The second updates the datapackage.json and pushes the changes to Github.

With these two things in place, we can continuously integrate our data!

## Installation

Add this line to your application's Gemfile:

    gem 'cid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cid

## Usage

Currently, Cid assumes your Datapackage lives in a cloned Github repo and has a structure like this:

```
datapackage.json
- folder
  |
  |_ schema.json
  |_ file.csv
  |_ ..
```

The schema.json file must match the [JSON table schema](http://dataprotocols.org/json-table-schema/).

You can have any number of folders, and each schema must correspond to the files within it.

Alternatively, you can specify your schema in your `datapackage.json` like so:

```JSON

{
  "name": "my-dataset",
  # here we list the data files in this dataset
  "resources": [
    {
      "path": "data.csv",
      "schema": {
        "fields": [
          {
            "name": "var1",
            "type": "string"
          },
          {
            "name": "var2",
            "type": "integer"
          },
          {
            "name": "var3",
            "type": "number"
          }
        ]
      }
    }
  ]
}

```

For more information, check out the [Tabular data package specification](http://dataprotocols.org/tabular-data-package/)

When you run `cid validate` on the command line, Cid loops through each folder and validates each csv against the schema. It also checks for any common errors like ragged rows and missing characters using [csvlint](https://github.com/theodi/csvlint.rb).

When you run `cid publish` on the command line, Cid (again), loops through each folder and adds each csv to the `datapackage.json`. It then pushes the changes to the GitHub repo. For this to happen sucessfully, you must have a Github API key, which you can specify either as an environment variable like so:

	export GITHUB_OAUTH_TOKEN="YOUR_TOKEN_HERE"

Or as a command line option like so:

	cid publish --github-token=YOUR_TOKEN_HERE

If you just want to skip the GitHub push altogether, just run

	cid publish --skip-github

## Getting this in Travis

Obviously, Cid is at its most powerful when used in a CI build. To get Cid working in Travis, simply run:

  	cid bootstrap --github-token=YOUR_TOKEN_HERE

This will create a `.travis.yml` to your repo and add your encrypted Github key.

Then just add your repo to Travis, and push your changes.

Now whenever someone makes a pull request on your data, Cid will validate the
data against the schema, and you'll get a nice build status telling you if it's good to go!

If the branch is master, it will also generate a new `datapackage.json` and push that to Github.

If you would rather generate the `datapackage.json` on a different branch (for example, `gh-pages`),
simply add the option `branch` like so:

  	cid bootstrap --github-token=YOUR_TOKEN_HERE --branch=gh-pages

You can also do this manually if you prefer - simply add a `.travis.yml` file to your repo
that looks a bit like this:

	before_script:
		- gem install cid
	script:
		- cid validate
	after_success:
		- '[ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && cid publish'

You'll also need to add your Github token to the `.travis.yml` file. To do this, just run:

	travis encrypt GITHUB_OAUTH_TOKEN="YOUR_TOKEN_HERE" --add

## Examples

There's only two repos that use Cid so far (it is a new thing after all), and you can see it here:

* https://github.com/theodi/euro-elections
* https://github.com/DemocracyClub/ge2015-candidates

If you decide to start using Cid, and want it listing here, open a PR and add it to this list!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
