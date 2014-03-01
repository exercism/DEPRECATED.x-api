require_relative 'test_helper'
require 'rack/test'
require 'approvals'
require 'yaml'
require 'xapi'
require 'app'

Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end
