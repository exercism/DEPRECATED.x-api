ENV['RACK_ENV'] = 'test'

if ENV['CI'].to_i == 1
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
  SimpleCov.command_name "Run PID: #{$PROCESS_ID}"
end

gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
FIXTURE_PATH = "./test/fixtures".freeze
