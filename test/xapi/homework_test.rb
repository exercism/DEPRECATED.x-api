require './test/test_helper'
require 'json'
require 'xapi/config'
require 'xapi/progression'
require 'xapi/problem'
require 'xapi/homework'

class HomeworkTest < Minitest::Test
  Namify = Proc.new{ |problem| [problem.language, problem.slug].join(':') }

  def homework_in(languages, data)
    homework = Xapi::Homework.new('abc123', languages, './test/fixtures')
    homework.stub(:data, data) do
      Xapi::Config.stub(:path, './test/fixtures') do
        yield homework
      end
    end
  end

  def test_handle_languages_they_havent_started_yet
    data = {'fake' => [{'slug' => 'one'}]}
    homework_in %w(fake fruit), data do |homework|
      expected = %w(fake:one fake:two fruit:apple)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_ignore_unknown_problem
    data = {'fake' => [{'slug' => 'unknown'}]}
    homework_in %w(fake), data do |homework|
      expected = %w(fake:one)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_start_a_new_track
    data = {'fake' => []}
    homework_in %w(fake), data do |homework|
      expected = %w(fake:one)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_serve_ongoing_track
    data = {
      'fake' => [
        {'slug' => 'one'},
        {'slug' => 'two'},
      ],
    }
    homework_in ['fake'], data do |homework|
      expected = %w(fake:one fake:two fake:three)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_serve_completed_track
    data = {
      'fake' => [
        {'slug' => 'one'},
        {'slug' => 'two'},
        {'slug' => 'three'},
      ],
    }
    homework_in ['fake'], data do |homework|
      expected = %w(fake:one fake:two fake:three)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_multiple_tracks
    data = {
      'fake' => [
        {'slug' => 'one'},
        {'slug' => 'two'},
      ],
      'fruit' => [
        {'slug' => 'apple'},
        {'slug' => 'banana'},
      ],
    }
    homework_in %w(fake fruit), data do |homework|
      expected = %w(fake:one fake:two fake:three fruit:apple fruit:banana fruit:cherry)
      assert_equal expected, homework.problems.map(&Namify)
    end
  end

  def test_fetch_a_single_track
    data = {
      'fake' => [
        {'slug' => 'one'},
        {'slug' => 'two'},
      ],
      'fruit' => [
        {'slug' => 'apple'},
        {'slug' => 'banana'},
      ],
    }
    homework_in %w(fake fruit), data do |homework|
      expected = %w(fruit:apple fruit:banana fruit:cherry)
      assert_equal expected, homework.problems_in('fruit').map(&Namify)
    end
  end
end
