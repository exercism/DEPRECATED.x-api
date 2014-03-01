require './test/test_helper'
require './test/vcr_helper'
require 'xapi/exercism_io'

class ExercismIOTest < Minitest::Test
  def test_current_exercises
    # If you delete the cassette, you will need to
    # run `rake xapi:seed` in exercism/exercism.io
    # and run the website locally on port 4567
    VCR.use_cassette('exercism_api_exercises') do
      expected = {
        'go' => ['leap'],
        'ruby' => ['anagram', 'word-count']
      }
      assert_equal expected, Xapi::ExercismIO.exercises_for('abc123')
    end
  end
end
