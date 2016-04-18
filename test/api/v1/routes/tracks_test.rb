require './test/v1_helper'
require './test/vcr_helper'

class V1RoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
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
end
