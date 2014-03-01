require './test/test_helper'
require 'xapi/progression'

class ProgressionTest < Minitest::Test
  def progression
    @progression ||= Xapi::Progression.new('fake', './test/fixtures')
  end

  def test_exercise_list
    assert_equal ['one', 'two', 'three'], progression.slugs
  end

  def test_next_in_line
    assert_equal 'two', progression.next(['one'])
    assert_equal 'three', progression.next(['one', 'two'])
    assert_equal 'two', progression.next(['one', 'three'])
    assert_equal 'one', progression.next(['three', 'two'])
    assert_equal nil, progression.next(['one', 'three', 'two'])
  end
end
