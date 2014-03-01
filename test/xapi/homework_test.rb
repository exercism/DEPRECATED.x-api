require './test/test_helper'
require './test/fixtures/fake_progression'
require 'xapi/homework'
require 'xapi/lesson'
require 'xapi/exercise'

class HomeworkTest < Minitest::Test
  def test_exercises
    data = {
      'ruby' => ['one', 'two'],
      'go' => ['one']
    }
    available_languages = ['ruby', 'go', 'python']
    homework = Xapi::Homework.new(data, available_languages, FakeProgression)

    expected = ['ruby:one', 'ruby:two', 'ruby:three', 'go:one', 'go:two', 'python:one']
    actual = homework.exercises.map {|exercise| [exercise.language, exercise.slug].join(':')}

    assert_equal expected.sort, actual.sort
  end
end
