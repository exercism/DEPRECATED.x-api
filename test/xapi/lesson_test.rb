require './test/test_helper'
require 'xapi/lesson'
require 'xapi/exercise'

class LessonTest < Minitest::Test
  def test_exercises
    data = [
      {"slug" => "one", "state" => "whatever"},
      {"slug" => "two", "state" => "whatever"},
    ]
    lesson = Xapi::Lesson.new('ruby', data, '/tmp')

    expected = ['one', 'two']
    actual = lesson.exercises.map(&:slug)

    assert_equal expected.sort, actual.sort
  end

  def test_language
    assert Xapi::Lesson.new('ruby', [], '/tmp').in?('ruby')
    refute Xapi::Lesson.new('ruby', [], '/tmp').in?('go')
  end
end
