require './test/test_helper'
require 'json'
require 'xapi/config'
require 'xapi/track'

class ConfigTest < Minitest::Test
  # Acceptance test -- actual production languages
  def test_languages
    expected = [
      "clojure", "coffeescript", "csharp", "elixir",
      "erlang", "fsharp", "go", "haskell", "javascript",
      "lua", "objective-c", "ocaml", "perl5",
      "python", "ruby", "scala", "swift"
    ].sort
    assert_equal expected, Xapi::Config.languages.sort
  end
end
