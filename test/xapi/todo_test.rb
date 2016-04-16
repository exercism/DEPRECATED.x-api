require './test/test_helper'
require 'xapi/todo'
require 'xapi/readme'
require 'xapi/config'
require 'xapi/track'
require 'xapi/metadata'
require 'xapi/problem'
require 'yaml'

class TodoTest < Minitest::Test
  def test_todo
    todo = Xapi::Todo.new('one', "./test/fixtures/")
    assert_equal "https://github.com/exercism/x-common/blob/master/one.md", todo.readme_url
    assert_equal todo.implementations.map(&:track_id), ['fake']
  end
end
