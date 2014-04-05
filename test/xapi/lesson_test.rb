require './test/test_helper'
require 'xapi/lesson'
require 'xapi/exercise'

class LessonTest < Minitest::Test
  def test_exercises
    lesson = Xapi::Lesson.new(['one', 'two'], 'ruby')

    expected = ['one', 'two']
    actual = lesson.exercises.map(&:slug)

    assert_equal expected.sort, actual.sort
  end

  def test_exercises_if_completed_progression
    lesson = Xapi::Lesson.new(['one', 'two', 'three'], 'ruby')

    expected = ['one', 'two', 'three']
    actual = lesson.exercises.map(&:slug)

    assert_equal expected.sort, actual.sort
  end
end
