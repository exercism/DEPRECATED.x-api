ENV['RACK_ENV'] = 'test'

if ENV['CI'].to_i == 1
  puts 'hi'
  require 'coveralls'
  Coveralls.wear!
end

gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

$: << File.expand_path('../../lib', __FILE__)
