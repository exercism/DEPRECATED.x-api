require './test/test_helper'
require 'json'
require 'xapi/track'
require 'xapi/problem'

class TrackTest < Minitest::Test
  def test_basic_configuration
    track = Xapi::Track.new("./test/fixtures/problems/fruit")
    assert track.active?
    assert_equal "fruit", track.id
    assert_equal "Fruit", track.language
    assert_equal %w(apple banana cherry), track.slugs
    assert_equal %w(apple banana cherry), track.problems.map(&:slug).sort
    assert_equal "https://example.com/exercism/xfruit", track.repository
  end

  def test_inactive_language
    track = Xapi::Track.new("./test/fixtures/problems/jewels")
    refute track.active?
    assert_equal "jewels", track.id
    assert_equal "Fancy Stones", track.language
  end

  def test_docs
    track = Xapi::Track.new("./test/fixtures/problems/fake")
    docs = track.docs

    content = {
      "hello" => "Module\n",
      "resources" => "Resources\n",
      "installation" => "Installing\n",
      "tools" => "Lint\n",
      "workflow" => "Running\n",
    }
    assert_equal content, docs.content
  end

  def test_null_track_docs
    track = Xapi::NullTrack.new('id')

    assert_instance_of Xapi::NullDocs, track.docs
  end
end
