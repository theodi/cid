$:.unshift File.join( File.dirname(__FILE__), "..", "..", "lib")

require 'rspec/expectations'
require 'pry'
require 'pry-remote'
require 'spork'
require 'aruba/cucumber'

World(RSpec::Matchers)

Before do
  @aruba_timeout_seconds = 10
end

Before('@validate') do
  @dirs = ["#{File.dirname(__FILE__)}/../.."]
end

After('@publish') do
  #`rm -rf tmp/aruba/`
end

Spork.each_run do
  require 'cid'
end
