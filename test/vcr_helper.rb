require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = './test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
