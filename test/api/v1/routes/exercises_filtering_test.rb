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

    assert_returns_tracks %w(fruit)
  end

  def test_that_you_may_filter_to_multiple_tracks
    getting '/v2/exercises?tracks=fake,jewels'

    assert_returns_tracks %w(fake jewels)
  end

  def test_that_empty_filter_returns_all
    getting '/v2/exercises?tracks='

    # animal is excluded, because there are no more exercises in
    # that track.
    assert_returns_tracks %w(fake fruit jewels)
  end

  def test_that_missing_filter_returns_all
    getting '/v2/exercises'

    # animal is excluded, because there are no more exercises in
    # that track.
    assert_returns_tracks %w(fake fruit jewels)
  end

  def test_that_blank_space_is_ignored
    getting '/v2/exercises?tracks=%20fake%20%20'

    assert_returns_tracks %w(fake)
  end

  def test_that_a_track_that_does_not_exist_returns_empty
    getting '/v2/exercises?tracks=xxx-does-not-exist-xxx'

    assert_returns_tracks []
  end

  private

  def getting(url)
    VCR.use_cassette('exercism_api_current_exercises') do
      get url, key: 'abc123'
    end
  end

  def assert_returns_tracks(expected_track_ids)
    actual_track_ids = JSON.parse(last_response.body)['problems'].map { |row|
      row['track_id']
    }.uniq

    assert_equal expected_track_ids.sort, actual_track_ids.sort
  end
end
