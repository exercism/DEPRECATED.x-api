require './test/app_helper'
require './test/vcr_helper'

class AppRoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  # More of a smoke test than anything else.
  # It will break as we add new languages.
  def test_all_the_tracks
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].map { |track| track['slug'] }
    Approvals.verify(tracks, name: 'get_tracks')
  end

  def test_all_the_todos
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].find { |track|
      track['slug'] == 'clojure'
    }['todo'].sort
    Approvals.verify(tracks, name: 'get_clojure_todo')
  end

  # Again, a smoke test.
  # It will break as the track gets updated, since
  # we're including the entire problem (not just the id).
  def test_a_track
    get '/tracks/ruby'
    Approvals.verify(last_response.body, format: :json, name: 'get_track_ruby')
  end

  def test_track_does_not_exist
    get '/tracks/rubby'
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
    get '/tracks/ruby/unknown'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem_with_readme
    get '/tracks/ruby/unknown/readme'

    assert_equal 404, last_response.status
  end

  def test_get_specific_problem
    get '/tracks/ruby/leap'
    options = { format: :json, name: 'get_specific_problem' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_readme
    get '/tracks/ruby/leap/readme'

    options = { format: :json, name: 'get_specific_problem_readme' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_tests
    get '/tracks/ruby/leap/tests'
    options = { format: :json, name: 'get_specific_problem_tests' }
    Approvals.verify(last_response.body, options)
  end
end
