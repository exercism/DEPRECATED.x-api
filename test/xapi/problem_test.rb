require './test/test_helper'
require 'yaml'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/problem'

class ProblemTest < Minitest::Test
  def test_assemble_problem
    problem = Xapi::Problem.new('fake', 'one', 'fresh', './test/fixtures')
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\nDo stuff.\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    files = {
      "README.md" => readme,
      "Fakefile" => "Autorun fake code\n",
      "one_test.test" => "assert 'one'\n",
    }
    assert_equal files, problem.files
    assert_equal 'fake', problem.language
    assert_equal 'one', problem.slug
  end

  def test_handle_missing_setup_instructions_gracefully
    problem = Xapi::Problem.new('ruby', 'one', 'fresh', './test/fixtures')
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal readme, problem.readme
  end

  def test_detects_unavailable_language
    problem = Xapi::Problem.new('fake', 'one', 'fresh', './test/fixtures')
    refute problem.not_found?

    problem = Xapi::Problem.new('unknown', 'slug', 'fresh', './test/fixtures')
    assert problem.not_found?
    assert_match /language/, problem.error_message
  end

  def test_detects_unavailable_problem
    problem = Xapi::Problem.new('fake', 'one', 'fresh', './test/fixtures')
    refute problem.not_found?

    problem = Xapi::Problem.new('fake', 'unknown', 'fresh', './test/fixtures')
    assert problem.not_found?
    assert_match /problem/, problem.error_message
  end

  def test_freshness
    problem = Xapi::Problem.new('fake', 'one', 'fresh', './test/fixtures')
    assert problem.fresh?
  end
end
