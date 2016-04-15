require 'bundler'

Bundler.require
$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'xapi'
require 'rewrite'

require 'v1'
run V1::App

require 'v3'
map '/v3/' do
  run V3::App
end
