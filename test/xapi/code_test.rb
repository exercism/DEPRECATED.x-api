require './test/test_helper'
require 'xapi/code'

class CodeTest < Minitest::Test
  attr_reader :code

  def test_exercise_in_root_dir
    code = Xapi::Code.new('./test/fixtures/tracks/fake/one')
    paths = [
      "./test/fixtures/tracks/fake/one/.dot",
      "./test/fixtures/tracks/fake/one/Fakefile",
      "./test/fixtures/tracks/fake/one/HINTS.md",
      "./test/fixtures/tracks/fake/one/one_test.ext",
      "./test/fixtures/tracks/fake/one/sub/src/stubfile.ext",
    ]
    assert_equal paths, code.paths

    files = {
      ".dot" => "dot\n",
      "Fakefile" => "Autorun fake code\n",
      "one_test.ext" => "assert 'one'\n",
      "HINTS.md" => "* one hint\n* one more hint\n",
      "sub/src/stubfile.ext" => "stub\n",
    }
    assert_equal files, code.files
  end
end
