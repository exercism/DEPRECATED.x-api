require './test/test_helper'
require 'xapi/course'
require 'xapi/lesson'
require 'xapi/exercise'

class CourseTest < Minitest::Test
  def test_exercises
    data = {
      'ruby' => ['one', 'two'],
      'go' => ['one']
    }
    available_languages = ['ruby', 'go', 'python']
    course = Xapi::Course.new(data, available_languages)

    expected = ['ruby:one', 'ruby:two', 'go:one']
    actual = course.lessons.map(&:exercises).flatten.map {|exercise|
      [exercise.language, exercise.slug].join(':')
    }

    assert_equal expected.sort, actual.sort
  end
end
