require './test/v1_helper'
require './test/vcr_helper'

class V1RoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::V1
  end

  def test_all_the_tracks
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].map { |track| track['slug'] }
    Approvals.verify(tracks, name: 'get_tracks')
  end

  def test_all_the_todos
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].find { |track|
      track['slug'] == 'fruit'
    }['todo'].sort
    Approvals.verify(tracks, name: 'get_fruit_todo')
  end

  def test_a_track
    get '/tracks/fake'
    Approvals.verify(last_response.body, format: :json, name: 'get_track_fake')
  end

  def test_track_does_not_exist
    get '/tracks/unknown'
    assert_equal last_response.status, 404
    Approvals.verify(last_response.body, format: :json, name: 'get_invalid_track')
  end

  def test_error_on_missing_language
    get '/tracks/unknown/language'

    assert_equal 404, last_response.status
  end

  def test_error_on_missing_language_with_readme
    get '/tracks/unknown/language/readme'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem
    get '/tracks/fake/unknown'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem_with_readme
    get '/tracks/fake/unknown/readme'

    assert_equal 404, last_response.status
  end

  def test_get_specific_problem
    get '/tracks/fake/three'
    options = { format: :json, name: 'get_specific_problem' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_readme
    get '/tracks/fake/three/readme'

    options = { format: :json, name: 'get_specific_problem_readme' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_tests
    get '/tracks/ruby/three/tests'
    options = { format: :json, name: 'get_specific_problem_tests' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_track_problems_in_right_order
    slugs_from_track = get_slugs_from('/tracks/fake')
    slugs_from_track_problems = get_slugs_from('/tracks/fake/problems')
    assert_equal slugs_from_track, slugs_from_track_problems
  end

  private

  def get_slugs_from(url)
    get url
    JSON.parse(last_response.body)['problems'].map { |p| p['slug'] }
  end
end
