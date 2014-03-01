require './test/app_helper'
require './test/vcr_helper'

class AppRoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_error_on_missing_language
    get '/exercises/unknown/language'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_exercise
    get '/exercises/ruby/unknown'

    assert_equal 404, last_response.status
  end

  def test_get_specific_exercise
    get '/exercises/ruby/leap'
    options = {:format => :json, :name => 'get_specific_exercises'}
    Approvals.verify(last_response.body, options)
  end

  def test_require_key_to_fetch_exercises
    get '/exercises'

    assert_equal 401, last_response.status
  end

  # Acceptance test. Relies on real language-specific data.
  # Expect it to fail regularly, since exercises get updated fairly frequently.
  def test_get_all_exercises
    VCR.use_cassette('exercism_api_exercises') do
      get '/exercises', :key => 'abc123'
      options = {:format => :json, :name => 'get_all_exercises'}
      Approvals.verify(last_response.body, options)
    end
  end
end
