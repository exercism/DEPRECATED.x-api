require './test/test_helper'
require 'json'
require 'xapi/track'

class TrackTest < Minitest::Test
  def test_basic_configuration
    config = Xapi::Track.new("./test/fixtures/problems/fruit")
    assert config.active?
    assert_equal "fruit", config.slug
    assert_equal "Fruit", config.language
    assert_equal ["apple", "banana", "cherry"], config.problems
  end

  def test_inactive_language
    config = Xapi::Track.new("./test/fixtures/problems/jewels")
    refute config.active?
    assert_equal "jewels", config.slug
    assert_equal "Fancy Stones", config.language
    assert_equal [], config.problems
  end
end
