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

  def test_require_key_to_fetch_exercises_for_language
    get '/exercises/ruby'

    assert_equal 401, last_response.status
  end

  def test_require_key_to_fetch_exercises
    get '/exercises'

    assert_equal 401, last_response.status
  end

  def test_require_key_to_restore_exercises
    get '/exercises/restore'

    assert_equal 401, last_response.status
  end

  # Acceptance tests. Relies on real language-specific data.
  # Expect it to fail regularly, since exercises get updated fairly frequently.

  def test_get_exercises_by_language
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/exercises/ruby', :key => 'abc123'
      options = {:format => :json, :name => 'get_current_exercises_by_language'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_handle_missing_exercise_by_language
    VCR.use_cassette('exercism_api_current_exercises_with_error') do
      get '/exercises/ruby', :key => 'xyz456'
      options = {:format => :json, :name => 'get_current_exercises_with_error_by_language'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_exercises
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/exercises', :key => 'abc123'
      options = {:format => :json, :name => 'get_current_exercises'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_handle_missing_exercise
    VCR.use_cassette('exercism_api_current_exercises_with_error') do
      get '/exercises', :key => 'xyz456'
      options = {:format => :json, :name => 'get_current_exercises_with_error'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_restore_exercises_and_solutions
    VCR.use_cassette('exercism_api_restore') do
      get '/exercises/restore', :key => 'abc123'
      options = {:format => :json, :name => 'restore'}
      Approvals.verify(last_response.body, options)
    end
  end
end
