require './test/v3_helper'
require './test/vcr_helper'

class V3RoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V3::App
  end

  def test_tracks
    get '/tracks'

    tracks = JSON.parse(last_response.body)["tracks"]
    expected = %w(animal fake fruit jewels)
    assert_equal expected, tracks.map {|track| track["id"]}.sort

    get '/tracks/fake'

    fake1 = tracks.find {|track| track["id"] == "fake"}
    fake2 = JSON.parse(last_response.body)["track"]
    assert_equal fake1, fake2

    Approvals.verify(fake2, name: 'v3_track')
  end
end
