require './test/test_helper'
require 'xapi/progression'

class ProgressionTest < Minitest::Test
  def test_exercise_list
    progression = Xapi::Progression.new('fake', './test/fixtures')
    assert_equal ['one', 'two', 'three'], progression.slugs
  end
end
