require './test/test_helper'
require 'xapi/course'
require 'xapi/lesson'
require 'xapi/problem'

class CourseTest < Minitest::Test
  def test_problems
    data = {
      'ruby' => [
        {"slug" => "one"},
        {"slug" => "two"},
      ],
      'go' => [
        {"slug" => "one"}
      ]
    }
    course = Xapi::Course.new(data, './tmp')

    expected = ['ruby:one', 'ruby:two', 'go:one']
    actual = course.lessons.map(&:problems).flatten.map {|problem|
      [problem.language, problem.slug].join(':')
    }

    assert_equal expected.sort, actual.sort
  end
end
