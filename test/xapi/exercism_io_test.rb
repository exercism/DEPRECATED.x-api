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
        'go' => ['leap'],
        'ruby' => ['anagram', 'word-count']
      }
      assert_equal expected, Xapi::ExercismIO.exercises_for('abc123')
    end
  end

  def test_code
    VCR.use_cassette('exercism_api_code') do
      expected = {
        "assignments" => [
          {"slug" => "leap", "track" => "go", "files" => {"one.go" => "// iteration 2 (done)"}},
          {"slug" => "anagram", "track" => "ruby", "files" => {"one.rb" => "// iteration 1 (pending)"}},
          {"slug" => "word-count", "track" => "ruby", "files" => {"two.rb" => "// iteration 1 (hibernating)"}}
        ]
      }
      assert_equal expected, Xapi::ExercismIO.code_for('abc123')
    end
  end
end
