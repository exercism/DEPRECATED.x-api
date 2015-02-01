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
      "python", "ruby", "scala", "swift"
    ].sort
    assert_equal expected, Xapi::Config.languages.sort
  end
end
