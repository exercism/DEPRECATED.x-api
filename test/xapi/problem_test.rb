require './test/test_helper'
require 'yaml'
require 'json'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/problem'
require 'xapi/tests'
require 'xapi/track'

class ProblemTest < Minitest::Test
  def attributes
    {
      track_id: 'fake',
      language: 'Who Cares',
      slug: 'one',
      path: './test/fixtures',
      repository: 'https://github.com/exercism/xfake',
    }
  end

  def test_assemble_problem
    problem = Xapi::Problem.new(attributes)
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n* one hint\n* one more hint\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    files = {
      "README.md" => readme,
      "Fakefile" => "Autorun fake code\n",
      "one_test.ext" => "assert 'one'\n",
      "sub/src/stubfile.ext" => "stub\n",
      ".dot" => "dot\n",
    }
    assert_equal files, problem.files
    assert_equal 'fake', problem.track_id
    assert_equal 'one', problem.slug
    assert_equal 'One', problem.name
    assert_equal 'This is one.', problem.blurb
    # TODO: make sure we use track_id everywhere
    # assert_equal 'Who Cares', problem.language
  end

  def test_handle_missing_setup_instructions_gracefully
    problem = Xapi::Problem.new(attributes.update(track_id: 'ruby'))
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal readme, problem.readme
  end

  def test_detects_unavailable_language
    problem = Xapi::Problem.new(attributes)
    assert problem.validate
    refute problem.not_found?

    problem = Xapi::Problem.new(attributes.update(track_id: 'unknown'))
    refute problem.validate
    assert problem.not_found?
    assert_match(/language/, problem.error_message)
  end

  def test_detects_unavailable_problem
    problem = Xapi::Problem.new(attributes)
    assert problem.validate
    refute problem.not_found?

    problem = Xapi::Problem.new(attributes.update(slug: 'unknown'))
    refute problem.validate
    assert problem.not_found?
    assert_match(/problem/, problem.error_message)
  end

  def test_naming
    problem = Xapi::Problem.new(attributes.update(slug: 'a-day-in-paradise'))
    assert_equal "A Day In Paradise", problem.name
  end

  def test_test_file
    expected = { "one_test.ext" => "assert 'one'\n" }
    problem = Xapi::Problem.new(attributes)
    assert_equal expected, problem.test_files
  end

  def test_zip
    problem = Xapi::Problem.new(attributes)
    file = Tempfile.new(['test', '.zip'])
    mock = MiniTest::Mock.new
    mock.expect(:write, file, [problem.dir, file.path])
    problem.zip(file: file, generator: mock)
    assert mock.verify
  end

  def test_files_in_exercises_dir
    expected = {
      "apple.ext" => "an apple a day keeps the doctor away\n",
      "apple.tst" => "assert 'apple'\n",
    }
    problem = Xapi::Problem.new(track_id: 'fruit', slug: 'apple', path: './test/fixtures')
    assert_equal expected, problem.code
  end

  def test_git_url
    attrs = {
      repository: 'http://example.com',
      path: './test/fixtures',
    }

    # not all tracks have moved their exercises to a subdirectory yet
    legacy = {
      track_id: 'fake',
      slug: 'one',
    }.merge(attrs)
    problem1 = Xapi::Problem.new(legacy)
    assert_equal "http://example.com/tree/master/one", problem1.git_url

    legit = {
      track_id: 'fruit',
      slug: 'apple',
    }.merge(attrs)
    problem2 = Xapi::Problem.new(legit)
    assert_equal "http://example.com/tree/master/exercises/apple", problem2.git_url
  end
end
