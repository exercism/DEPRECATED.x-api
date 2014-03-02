require './test/test_helper'
require 'yaml'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/exercise'

class ExerciseTest < Minitest::Test
  def test_assemble_exercise
    exercise = Xapi::Exercise.new('fake', 'one', './test/fixtures')
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\nDo stuff.\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    files = {
      "README.md" => readme,
      "Fakefile" => "Autorun fake code\n",
      "one_test.test" => "assert 'one'\n",
    }
    assert_equal files, exercise.files
    assert_equal 'fake', exercise.language
    assert_equal 'one', exercise.slug
  end

  def test_handle_missing_setup_instructions_gracefully
    exercise = Xapi::Exercise.new('ruby', 'one', './test/fixtures')
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal readme, exercise.readme
  end

  def test_detects_unavailable_language
    exercise = Xapi::Exercise.new('fake', 'one', './test/fixtures')
    refute exercise.not_found?

    exercise = Xapi::Exercise.new('unknown', 'slug', './test/fixtures')
    assert exercise.not_found?
    assert_match /language/, exercise.error_message
  end

  def test_detects_unavailable_exercise
    exercise = Xapi::Exercise.new('fake', 'one', './test/fixtures')
    refute exercise.not_found?

    exercise = Xapi::Exercise.new('fake', 'unknown', './test/fixtures')
    assert exercise.not_found?
    assert_match /exercise/, exercise.error_message
  end
end
