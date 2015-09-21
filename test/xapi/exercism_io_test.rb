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
          { "slug" => "leap", "state" => "archived" },
        ],
        "haskell" => [
          { "slug" => "list-ops", "state" => "active" },
          { "slug" => "word-count", "state" => "active" },
        ],
      }
      assert_equal expected, Xapi::ExercismIO.exercises_for('abc123')
    end
  end

  def test_code
    VCR.use_cassette('exercism_api_code') do
      expected = [
        { "slug" => "leap", "track" => "go", "files" => { "leap.go" => "// iteration 2" } },
        { "slug" => "list-ops", "track" => "haskell", "files" => { "ListOps.hs" => "// iteration 1" } },
        { "slug" => "word-count", "track" => "haskell", "files" => { "WordCount.hs" => "// iteration 1" } },
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
