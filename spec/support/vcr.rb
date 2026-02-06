require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<DATOCMS_API_TOKEN>") { ENV["DATOCMS_API_TOKEN"] }
  config.configure_rspec_metadata!
end
