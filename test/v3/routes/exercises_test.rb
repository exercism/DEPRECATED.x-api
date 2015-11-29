require './test/v3_helper'
require './test/vcr_helper'

class V3RoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V3::App
  end

  def test_readme
    get '/tracks/fake/exercises/three/readme'

    options = { format: :json, name: 'v3_readme' }
    Approvals.verify(last_response.body, options)
  end

  def test_test_with_multiple_files_and_no_pattern
    get '/tracks/animal/exercises/dog/tests'

    options = { format: :json, name: 'v3_exercise_tests' }
    Approvals.verify(last_response.body, options)
  end

  def test_exists
    get '/tracks/fake/exercises/three/exists'
    assert_equal 200, last_response.status
    options = { format: :json, name: 'v3_exercise_exists' }
    Approvals.verify(last_response.body, options)

    get '/tracks/fake/exercises/hundred/exists'
    assert_equal 404, last_response.status
    options = { format: :json, name: 'v3_exercise_does_not_exist' }
    Approvals.verify(last_response.body, options)
  end
end
