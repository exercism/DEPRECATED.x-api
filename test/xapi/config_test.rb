require './test/test_helper'
require 'json'
require 'xapi/config'
require 'xapi/track'

class ConfigTest < Minitest::Test
  def setup
    @fixtures_problems_path = "./test/fixtures/"
    @config =  Xapi::Config.new(@fixtures_problems_path)
  end

  # Acceptance test -- actual production languages
  def test_prod_languages
    config = Xapi::Config.new(".")

    expected = [
      "clojure",
      "coffeescript",
      "cpp",
      "csharp",
      "elisp",
      "elixir",
      "erlang",
      "fsharp",
      "go",
      "haskell",
      "java",
      "javascript",
      "lfe",
      "lisp",
      "lua",
      "objective-c",
      "ocaml",
      "perl5",
      "php",
      "plsql",
      "python",
      "ruby",
      "rust",
      "scala",
      "scheme",
      "swift",
    ].sort
    assert_equal expected, config.languages.sort
  end

  def test_languages
    expected = %w(animal fake fruit)

    assert_equal expected, @config.languages.sort
  end

  def test_tracks
    tracks = @config.tracks
    expected = %w(animal fake fruit jewels)

    assert_equal expected, tracks.map(&:id)
  end

  def test_find_existing_track
    track = @config.find("fake")

    assert track.instance_of? Xapi::Track
    assert_equal "fake", track.id
  end

  def test_find_non_existing_track
    track = @config.find("foo")

    assert track.instance_of? Xapi::NullTrack
  end
end
