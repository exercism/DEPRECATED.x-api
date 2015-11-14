require './test/v1_helper'
require './test/vcr_helper'

class V1RoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::V1
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

  # Acceptance tests. Relies on real language-specific data.
  # Expect it to fail regularly, since exercises get updated fairly frequently.

  def test_get_problems_by_language
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises/fruit', key: 'abc123'
      options = { format: :json, name: 'get_current_problems_by_language_v2' }
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_problems
    VCR.use_cassette('exercism_api_current_exercises_v2', record: :new_episodes) do
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
    VCR.use_cassette('exercism_api_restore_v2') do
      get '/v2/exercises/restore', key: 'abc123'
      options = { format: :json, name: 'restore_v2' }
      Approvals.verify(last_response.body, options)
    end
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
