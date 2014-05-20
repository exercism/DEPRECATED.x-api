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
    tracks = JSON.parse(last_response.body)['tracks'].map {|track| track['slug']}
    Approvals.verify(tracks, name: 'get_tracks')
  end
end
