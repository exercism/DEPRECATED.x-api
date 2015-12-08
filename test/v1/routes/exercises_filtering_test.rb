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
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises?tracks=fruit', key: 'abc123'

      assert_equal ['fruit'], last_tracks
    end
  end

  def test_that_you_may_filter_to_multiple_tracks
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises?tracks=fruit,animal', key: 'abc123'

      assert_equal ['animal', 'fruit'], last_tracks
    end
  end

  def test_that_empty_filter_returns_all
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises?tracks=', key: 'abc123'

      assert_equal ['animal', 'fake', 'fruit'], last_tracks
    end
  end

  def test_that_blank_space_is_ignored
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises?tracks=%20animal%20%20', key: 'abc123'
      
      assert_equal ['animal'], last_tracks
    end
  end

  private

  def last_tracks
    json = JSON.parse(last_response.body)
      
    tracks_received = json['problems'].map{|it| it['track_id']}.uniq
  end
end