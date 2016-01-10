require './test/test_helper'
require 'xapi/code'

class CodeTest < Minitest::Test
  attr_reader :code

  def path_to(file)
    "./test/fixtures/tracks/fake/one/#{file}"
  end

  def setup
    @code = Xapi::Code.new('./test/fixtures/tracks/fake/one')
  end

  def test_paths
    expected = [
      path_to(".dot"),
      path_to("Fakefile"),
      path_to("one_test.tst"),
    ]
    assert_equal expected, code.paths
  end

  def test_deliver_applicable_files
    expected = {
      ".dot" => "dot\n",
      "Fakefile" => "Autorun fake code\n",
      "one_test.tst" => "assert 'one'\n",
    }
    assert_equal expected, code.files
  end
end
