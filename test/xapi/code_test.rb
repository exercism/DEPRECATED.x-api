require './test/test_helper'
require 'xapi/code'

class CodeTest < Minitest::Test
  attr_reader :code

  def setup
    @code = Xapi::Code.new('./test/fixtures/exercises/fake/one')
  end

  def test_glob
    expected = [
      "./test/fixtures/exercises/fake/one/Fakefile",
      "./test/fixtures/exercises/fake/one/example.ext",
      "./test/fixtures/exercises/fake/one/one_test.test",
      "./test/fixtures/exercises/fake/one/sub/src/ExampleFile.ext"
    ]
    assert_equal expected.sort, code.glob.sort
  end

  def test_paths
    expected = [
      "./test/fixtures/exercises/fake/one/Fakefile",
      "./test/fixtures/exercises/fake/one/one_test.test"
    ]
    assert_equal expected, code.paths
  end

  def test_deliver_applicable_files
    expected = {
      "Fakefile" => "Autorun fake code\n",
      "one_test.test" => "assert 'one'\n",
    }
    assert_equal expected, code.files
  end
end
