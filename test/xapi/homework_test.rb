require './test/test_helper'
require 'json'
require 'xapi/course'
require 'xapi/lesson'
require 'xapi/progression'
require 'xapi/problem'
require 'xapi/homework'

class HomeworkTest < Minitest::Test
  Namify = Proc.new{ |problem| [problem.language, problem.slug].join(':') }

  def homework_in(languages, data)
    homework = Xapi::Homework.new('abc123', languages, './test/fixtures')
    homework.stub(:data, data) do
      yield homework
    end
  end

  def test_start_a_new_track
    data = {'fake' => []}
    homework_in ['fake'], data do |homework|
      expected = ['fake:one']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_exclude_completed_problem
    data = {'fake' => [{'slug' => 'one', 'state' => 'done'}]}
    homework_in ['fake'], data do |homework|
      expected = ['fake:two']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_serve_active_problem
    data = {'fake' => [{'slug' => 'one', 'state' => 'pending'}]}
    homework_in ['fake'], data do |homework|
      expected = ['fake:one', 'fake:two']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_ignore_unknown_problem
    data = {'fake' => [{'slug' => 'unknown', 'state' => 'pending'}]}
    homework_in ['fake'], data do |homework|
      expected = ['fake:one']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_serve_ongoing_track
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
      ]
    }
    homework_in ['fake'], data do |homework|
      expected = ['fake:two', 'fake:three']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_serve_completed_track
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
        {'slug' => 'three', 'state' => 'pending'},
      ]
    }
    homework_in ['fake'], data do |homework|
      expected = ['fake:two', 'fake:three']
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_multiple_tracks
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
      ],
      'fruit' => [
        {'slug' => 'apple', 'state' => 'done'},
        {'slug' => 'banana', 'state' => 'pending'},
      ]
    }
    homework_in ['fake', 'fruit'], data do |homework|
      expected = ["fake:two", "fake:three", "fruit:banana", "fruit:cherry"]
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_fetch_a_single_track
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
      ],
      'fruit' => [
        {'slug' => 'apple', 'state' => 'done'},
        {'slug' => 'banana', 'state' => 'pending'},
      ]
    }
    homework_in ['fake', 'fruit'], data do |homework|
      expected = ["fruit:banana", "fruit:cherry"]
      assert_equal expected, homework.problems_in('fruit').map(&Namify)
    end
  end
end
