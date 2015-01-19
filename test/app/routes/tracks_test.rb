require './test/app_helper'
require './test/vcr_helper'

class AppRoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  # More of a smoke test than anything else.
  # It will break as we add new languages.
  def test_some_other_error
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].map { |track| track['slug'] }
    Approvals.verify(tracks, name: 'get_tracks')
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
end
