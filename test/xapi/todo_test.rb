require './test/test_helper'
require 'xapi/todo'
require 'xapi/readme'
require 'xapi/config'
require 'xapi/track'
require 'xapi/metadata'
require 'xapi/problem'
require 'yaml'

class TodoTest < Minitest::Test
  def setup
    @path = "./test/fixtures/"
  end

  def test_readme
    todo = Xapi::Todo.new('one', @path)
    readme = Xapi::Readme.new('one', @path)
    assert_equal readme.text, todo.readme.text
  end

  def test_implemented_examples
    todo = Xapi::Todo.new('one', @path)
    implemented_examples = todo.implemented_examples
    assert_equal implemented_examples.map(&:track_id), ['fake']
  end
end
