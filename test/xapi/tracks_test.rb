require_relative 'test_helper'
require_relative '../../lib/xapi'

class TracksTest < Minitest::Test
  def test_collection
    tracks = Xapi::Tracks.new(FIXTURE_PATH)

    # can access it like an array
    ids = %w(animal fake jewels fruit)
    assert_equal ids, tracks.map(&:id)

    # can access it like a hash
    assert_equal "Fruit", tracks["fruit"].language

    # handles null tracks
    refute tracks["no-such-track"].exists?
  end
end
