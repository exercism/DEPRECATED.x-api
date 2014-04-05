require './test/test_helper'
require './test/fixtures/fake_progression'
require 'xapi/lesson'
require 'xapi/exercise'

class LessonTest < Minitest::Test
  def test_exercises
    lesson = Xapi::Lesson.new(['one', 'two'], FakeProgression.new('ruby', '/fake/path'))

    expected = ['one', 'two']
    actual = lesson.exercises.map(&:slug)

    assert_equal expected.sort, actual.sort
  end

  def test_exercises_if_completed_progression
    lesson = Xapi::Lesson.new(['one', 'two', 'three'], FakeProgression.new('ruby', '/fake/path'))

    expected = ['one', 'two', 'three']
    actual = lesson.exercises.map(&:slug)

    assert_equal expected.sort, actual.sort
  end
end
