require './test/test_helper'
require 'yaml'
require 'json'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/problem'
require 'xapi/tests'

class ProblemTest < Minitest::Test
  def attributes
    {
      track_id: 'fake',
      language: 'Who Cares',
      slug: 'one',
      path: './test/fixtures',
    }
  end

  def test_assemble_problem
    problem = Xapi::Problem.new(attributes)
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\nDo stuff.\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    files = {
      "README.md" => readme,
      "Fakefile" => "Autorun fake code\n",
      "one_test.tst" => "assert 'one'\n",
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
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
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
    expected = { "one_test.tst" => "assert 'one'\n" }
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
end
