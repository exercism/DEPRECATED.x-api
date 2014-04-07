require './test/test_helper'
require 'xapi/course'
require 'xapi/lesson'
require 'xapi/progression'
require 'xapi/exercise'
require 'xapi/homework'

class HomeworkTest < Minitest::Test
  Namify = Proc.new{ |exercise| [exercise.language, exercise.slug].join(':') }

  def test_start_a_new_track
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {'fake' => []}
    homework.stub(:data, data) do
      expected = ['fake:one']
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_exclude_completed_exercise
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {'fake' => [{'slug' => 'one', 'state' => 'done'}]}
    homework.stub(:data, data) do
      expected = ['fake:two']
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_serve_active_exercise
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {'fake' => [{'slug' => 'one', 'state' => 'pending'}]}
    homework.stub(:data, data) do
      expected = ['fake:one', 'fake:two']
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_ignore_unknown_exercise
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {'fake' => [{'slug' => 'unknown', 'state' => 'pending'}]}
    homework.stub(:data, data) do
      expected = ['fake:one']
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_serve_ongoing_track
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
      ]
    }
    homework.stub(:data, data) do
      expected = ['fake:three', 'fake:two'] # sorted alphabetically
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_serve_completed_track
    homework = Xapi::Homework.new('abc123', ['fake'], './test/fixtures')
    data = {
      'fake' => [
        {'slug' => 'one', 'state' => 'done'},
        {'slug' => 'two', 'state' => 'pending'},
        {'slug' => 'three', 'state' => 'pending'},
      ]
    }
    homework.stub(:data, data) do
      expected = ['fake:three', 'fake:two'] # sorted alphabetically
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_multiple_tracks
    homework = Xapi::Homework.new('abc123', ['fake', 'fruit'], './test/fixtures')
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
    homework.stub(:data, data) do
      expected = ["fake:three", "fake:two", "fruit:banana", "fruit:cherry"]
      assert_equal expected, homework.exercises.map(&Namify)
    end
  end

  def test_fetch_a_single_track
    homework = Xapi::Homework.new('abc123', ['fake', 'fruit'], './test/fixtures')
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
    homework.stub(:data, data) do
      expected = ["fruit:banana", "fruit:cherry"]
      assert_equal expected, homework.exercises_in('fruit').map(&Namify)
    end
  end
end
