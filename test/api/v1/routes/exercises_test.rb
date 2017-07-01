require './test/v1_helper'
require './test/vcr_helper'

class V1RoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  def test_protected_endpoints
    [
      '/v2/exercises/ruby',
      '/v2/exercises',
      '/v2/exercises/restore',
    ].each do |endpoint|
      get endpoint
      assert_equal 401, last_response.status, "GET #{endpoint} should be protected"
    end
  end

  def test_get_problems_by_language
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/v2/exercises/fruit', key: 'abc123'
      options = { format: :json, name: 'get_current_problems_by_language_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_the_first_problem_in_a_language
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/v2/exercises/jewels', key: 'abc123'
      options = { format: :json, name: 'get_first_problem_in_language_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  # Don't deliver hello-world if you've already solved exercises in that language,
  # even if you never solved hello world.
  def test_get_problems
    VCR.use_cassette('exercism_api_current_exercises', record: :new_episodes) do
      get '/v2/exercises', key: 'abc123'

      options = { format: :json, name: 'get_current_problems_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_single_problems
    VCR.use_cassette('exercism_api_single_exercise_v2') do
      get '/v2/exercises/fruit/apple'

      options = { format: :json, name: 'get_single_problem_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_restore_exercises_and_solutions
    VCR.use_cassette('exercism_api_restore') do
      get '/v2/exercises/restore', key: 'abc123'
      options = { format: :json, name: 'restore_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_exercises_by_track
    get '/v2/exercises/invalid_track', key: 'abc123'
    options = { format: :json, name: 'get_exercises_invalid_track_error' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_by_track_slug_invalid_track
    get '/v2/exercises/invalid_track/apple', key: 'abc123'
    options = { format: :json, name: 'get_exercises_invalid_track_error' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_by_track_slug_invalid_slug
    get '/v2/exercises/fruit/invalid_slug', key: 'abc123'
    options = { format: :json, name: 'get_exercises_invalid_slug_error' }
    Approvals.verify(last_response.body, options)
  end

  def test_api_error
    VCR.use_cassette('exercism_api_error') do
      get '/v2/exercises', key: 'no-such-key'
      options = { format: :json, name: 'error' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_some_other_error
    error = proc { fail Exception.new("failing hard") }

    Xapi::ExercismIO.stub(:request, error) do
      get '/v2/exercises', key: 'who-cares'
      body = JSON.parse(last_response.body)
      assert_equal ["failing hard"], body["error"]
    end
  end
end
