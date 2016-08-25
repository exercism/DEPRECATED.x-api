require_relative '../test_helper'
require_relative '../../lib/xapi/problem'
require_relative '../../lib/xapi/problems'

class ProblemsTest < Minitest::Test
  def test_collection
    problems = Xapi::Problems.new(FIXTURE_PATH)

    # can access it like an array
    slugs = [
      "mango", "apple", "banana", "cherry", "dog", "hello-world", "one", "three", "two"
    ]
    assert_equal slugs, problems.map(&:slug)

    # can access it like a hash
    assert_equal "Cherry", problems["cherry"].name

    # handles null problems
    refute problems["no-such-problem"].exists?

    # kind of dirty set operation
    slugs = %w(one two three apple mango)
    todos = %w(dog hello-world banana cherry).sort
    assert_equal todos, problems - slugs
  end
end
