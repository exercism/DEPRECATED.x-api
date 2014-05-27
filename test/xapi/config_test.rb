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
end
