require './test/test_helper'
require 'xapi/code'

class CodeTest < Minitest::Test
  attr_reader :code

  def test_code
    code = Xapi::Code.new('./test/fixtures/tracks/fake/one')
    paths = [
      "./test/fixtures/tracks/fake/one/.dot",
      "./test/fixtures/tracks/fake/one/Fakefile",
      "./test/fixtures/tracks/fake/one/one_test.tst",
    ]
    assert_equal paths, code.paths

    files = {
      ".dot" => "dot\n",
      "Fakefile" => "Autorun fake code\n",
      "one_test.tst" => "assert 'one'\n",
    }
    assert_equal files, code.files
  end
end
