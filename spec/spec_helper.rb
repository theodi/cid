require 'coveralls'
Coveralls.wear!

require 'cid'
require 'pry'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<GITHUB_OAUTH_TOKEN>') { ENV['GITHUB_OAUTH_TOKEN'] }
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  
  config.order = "random"
end
