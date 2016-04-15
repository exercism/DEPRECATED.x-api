require_relative 'test_helper'
require_relative '../../lib/rewrite/problem'
require_relative '../../lib/rewrite/problems'

class RewriteProblemsTest < Minitest::Test
  def test_collection
    problems = Rewrite::Problems.new(FIXTURE_PATH)

    # can access it like an array
    slugs = [
      "apple", "banana", "cherry", "dog", "hello-world", "one", "three", "two"
    ]
    assert_equal slugs, problems.map(&:slug)

    # can access it like a hash
    assert_equal "Cherry", problems["cherry"].name

    # handles null problems
    refute problems["no-such-problem"].exists?

    # kind of dirty set operation
    slugs = %w(one two three apple)
    todos = %w(dog hello-world banana cherry).sort
    assert_equal todos, problems - slugs
  end
end
