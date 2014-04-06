require './test/test_helper'
require 'xapi/exercise'
require 'xapi/progression'

class ProgressionTest < Minitest::Test

  def progression_with(current_slugs)
    Xapi::Progression.new('fake', current_slugs, './test/fixtures')
  end

  def test_exercise_list
    assert_equal ['one', 'two', 'three'], progression_with([]).slugs
  end

  def test_next_in_line
    assert_equal 'two', progression_with(['one']).next.slug
    assert_equal 'three', progression_with(['one', 'two']).next.slug
    assert_equal 'two', progression_with(['one', 'three']).next.slug
    assert_equal 'one', progression_with(['three', 'two']).next.slug
    assert_equal 'no-such-exercise', progression_with(['one', 'three', 'two']).next.slug
  end
end
