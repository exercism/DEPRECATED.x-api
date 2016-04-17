ENV['RACK_ENV'] = 'test'

if ENV['CI'].to_i == 1
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end

gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

FIXTURE_PATH = "./test/fixtures"
