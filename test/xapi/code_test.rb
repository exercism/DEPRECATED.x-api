require './test/test_helper'
require 'xapi/code'

class CodeTest < Minitest::Test
  attr_reader :code

  def path_to(file)
    "./test/fixtures/problems/fake/one/#{file}"
  end

  def setup
    @code = Xapi::Code.new('./test/fixtures/problems/fake/one')
  end

  def test_glob
    expected = [
      path_to("Fakefile"),
      path_to("example.ext"),
      path_to("one_test.tst"),
      path_to("sub/src/ExampleFile.ext"),
    ]
    assert_equal expected.sort, code.glob.sort
  end

  def test_paths
    expected = [
      path_to("Fakefile"),
      path_to("one_test.tst"),
    ]
    assert_equal expected, code.paths
  end

  def test_deliver_applicable_files
    expected = {
      "Fakefile" => "Autorun fake code\n",
      "one_test.tst" => "assert 'one'\n",
    }
    assert_equal expected, code.files
  end
end
