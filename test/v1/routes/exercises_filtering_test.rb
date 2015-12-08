require './test/v1_helper'
require 'rack/test'
require './test/vcr_helper'

class V1RoutesExerciseFilteringTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  # 
  # Right now we have /v2/exercises and /v2/exercises/:track_id. Let's tweak the /v2/exercises to
  # take an optional parameter ?tracks=a,b,c and if that parameter is passed, only return the data for those tracks.
  #

  def test_that_you_may_filter_to_single_track
    getting '/v2/exercises?tracks=fruit'

    returns_tracks ['fruit']
  end

  def test_that_you_may_filter_to_multiple_tracks
    getting '/v2/exercises?tracks=fruit,animal'

    returns_tracks ['animal', 'fruit']
  end

  def test_that_empty_filter_returns_all
    getting '/v2/exercises?tracks='

    returns_tracks ['animal', 'fake', 'fruit']
  end

  def test_that_missing_filter_returns_all
    getting '/v2/exercises'

    returns_tracks ['animal', 'fake', 'fruit']
  end

  def test_that_blank_space_is_ignored
    getting '/v2/exercises?tracks=%20animal%20%20'

    returns_tracks ['animal']
  end

  def test_that_a_track_that_does_not_exist_returns_empty
    getting '/v2/exercises?tracks=xxx-does-not-exist-xxx'
    
    returns_tracks []
  end

  private

  def getting(url)
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get url, key: 'abc123'
    end
  end

  def returns_tracks(expected_tracks=[])
    assert_equal expected_tracks, last_tracks
  end

  def last_tracks
    json = JSON.parse(last_response.body)

    tracks_received = json['problems'].map{|it| it['track_id']}.uniq
  end
end
