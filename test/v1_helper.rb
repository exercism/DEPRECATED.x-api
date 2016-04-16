require_relative 'test_helper'
require 'rack/test'
require 'approvals'
require 'yaml'
require 'xapi'
require 'rewrite'
require_relative '../v1'

Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end
