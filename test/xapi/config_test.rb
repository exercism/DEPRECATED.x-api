require './test/test_helper'
require 'json'
require 'xapi/config'
require 'xapi/track'

class ConfigTest < Minitest::Test
  # Acceptance test -- actual production languages
  def test_languages
    expected = [
      "clojure", "coffeescript", "cpp", "csharp", "elixir",
      "erlang", "fsharp", "go", "haskell", "java", "javascript",
      "lisp", "lua", "objective-c", "ocaml", "perl5", "plsql",
      "php", "python", "ruby", "scala", "swift", "scheme"
    ].sort
    assert_equal expected, Xapi::Config.languages.sort
  end
end
