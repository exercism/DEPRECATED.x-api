require './test/test_helper'
require './test/fixtures/fake_progression'
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
    course = Xapi::Course.new(data, available_languages, FakeProgression)

    expected = ['ruby:one', 'ruby:two', 'ruby:three', 'go:one', 'go:two', 'python:one']
    actual = course.lessons.map(&:exercises).flatten.map {|exercise|
      [exercise.language, exercise.slug].join(':')
    }

    assert_equal expected.sort, actual.sort
  end
end
