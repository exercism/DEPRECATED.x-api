require './test/test_helper'
require './test/vcr_helper'
require 'xapi/exercism_io'

# If you delete the cassettes, you will need to
# run `rake xapi:seed` in exercism/exercism.io
# and run the website locally on port 4567
class ExercismIOTest < Minitest::Test
  def test_exercises
    VCR.use_cassette('exercism_api_exercises') do
      expected = {
        "go" => [
          {"slug" => "leap", "state" => "done"}
        ],
        "ruby" => [
          {"slug" => "anagram", "state" => "pending"},
          {"slug" => "word-count", "state" => "hibernating"}
        ]
      }
      assert_equal expected, Xapi::ExercismIO.exercises_for('abc123')
    end
  end

  def test_code
    VCR.use_cassette('exercism_api_code') do
      expected = [
        {"slug" => "leap", "track" => "go", "files" => {"leap.go" => "// iteration 2 (done)"}},
        {"slug" => "anagram", "track" => "ruby", "files" => {"anagram.rb" => "// iteration 1 (pending)"}},
        {"slug" => "word-count", "track" => "ruby", "files" => {"word-count.rb" => "// iteration 1 (hibernating)"}}
      ]
      assert_equal expected, Xapi::ExercismIO.code_for('abc123')
    end
  end

  def test_passes_error_on
    VCR.use_cassette('exercism_api_error') do
      assert_raises Xapi::ApiError do
        Xapi::ExercismIO.exercises_for('no-such-key')
      end
    end
  end
end
