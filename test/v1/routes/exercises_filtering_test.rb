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

      options = { format: :json, name: 'get_current_problems_by_language_v2' }

      json = JSON.parse(last_response.body)
      
      tracks_received = json['problems'].map{|it| it['track_id']}.uniq

      assert_equal ['fruit'], tracks_received
    end
  end

  def test_that_empty_filter_returns_all
    VCR.use_cassette('exercism_api_current_exercises_v2') do
      get '/v2/exercises?tracks=', key: 'abc123'

      options = { format: :json, name: 'get_current_problems_by_language_v2' }

      json = JSON.parse(last_response.body)
      
      tracks_received = json['problems'].map{|it| it['track_id']}.uniq

      assert_equal ['animal', 'fake', 'fruit'], tracks_received
    end
  end

  # TEST: use comma or semi?
end
