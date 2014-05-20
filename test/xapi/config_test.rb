require './test/test_helper'
require 'json'
require 'xapi/config'

class ConfigTest < Minitest::Test
  # Acceptance test -- actual production languages
  def test_languages
    expected = [
      "clojure", "coffeescript", "csharp", "elixir",
      "go", "haskell", "javascript",
      "objective-c", "ocaml", "perl5",
      "python", "ruby", "scala"
    ].sort
    assert_equal expected, Xapi::Config.languages.sort
  end

  def test_basic_configuration
    config = Xapi::Config.new("./test/fixtures/problems/fruit")
    assert config.active?
    assert_equal "fruit", config.slug
    assert_equal "Fruit", config.language
    assert_equal ["apple", "banana", "cherry"], config.problems
  end

  def test_inactive_language
    config = Xapi::Config.new("./test/fixtures/problems/jewels")
    refute config.active?
    assert_equal "jewels", config.slug
    assert_equal "Fancy Stones", config.language
    assert_equal [], config.problems
  end
end
