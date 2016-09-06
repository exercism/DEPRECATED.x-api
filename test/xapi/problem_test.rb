require_relative '../test_helper'
require_relative '../../lib/xapi/problem'

class ProblemTest < Minitest::Test
  def test_existing_problem
    problem = Xapi::Problem.new('hello-world', FIXTURE_PATH)

    assert problem.exists?, "hello world files not found in the metadata dir"
    assert_equal 'hello-world', problem.slug
    assert_equal 'Hello World', problem.name
    assert_equal 'Oh, hello.', problem.blurb
    assert_equal "* hello\n* hello again\n", problem.description
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', problem.yaml_url
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/description.md', problem.md_url

    assert_equal "## Source\n\nThe internet. [http://example.com](http://example.com)", problem.source_markdown
    assert_equal 'The internet.', problem.source
    assert_equal 'http://example.com', problem.source_url
  end

  def test_for_problems_in_exercise_folder_location
    problem = Xapi::Problem.new('mango', FIXTURE_PATH)

    assert problem.exists?, "mango files not found in the metadata dir"
    assert_equal 'mango', problem.slug
    assert_equal 'Mango', problem.name
    assert_equal 'This is mango.', problem.blurb
    assert_equal "* mango\n* mango again\n", problem.description
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/mango/metadata.yml', problem.yaml_url
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/mango/description.md', problem.md_url
    assert_equal "## Source\n\nThe mango. [http://example.com](http://example.com)", problem.source_markdown
    assert_equal 'The mango.', problem.source
    assert_equal 'http://example.com', problem.source_url
  end

  def test_json_url
    # when JSON file exists
    problem = Xapi::Problem.new('mango', FIXTURE_PATH)
    assert_equal "https://github.com/exercism/x-common/blob/master/exercises/mango/canonical-data.json", problem.json_url

    # missing JSON file
    problem = Xapi::Problem.new('banana', FIXTURE_PATH)
    assert_equal nil, problem.json_url
  end

  def test_source_markdown_no_url
    problem = Xapi::Problem.new('apple', FIXTURE_PATH)
    assert_equal "## Source\n\nThe internet.", problem.source_markdown
  end

  def test_source_markdown_no_source
    problem = Xapi::Problem.new('banana', FIXTURE_PATH)
    assert_equal "## Source\n\n[http://example.com](http://example.com)", problem.source_markdown
  end

  def test_no_source
    problem = Xapi::Problem.new('cherry', FIXTURE_PATH)
    assert_equal "", problem.source_markdown
  end

  def test_no_such_problem
    refute Xapi::Problem.new('no-such-problem', FIXTURE_PATH).exists?
  end
end
