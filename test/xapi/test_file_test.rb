require './test/test_helper'
require 'json'
require 'xapi/test_file'

class TestFileTest < Minitest::Test
  def files
    {
      "README.md" => "This is a readme",
      "Fakefile" => "Autorun fake code\n",
      "a_dog.animal" => "assert 'woof woof'\n",
    }
  end

  def attributes
    { path: './test/fixtures/tracks/animal', files: files }
  end

  def test_assemble_test_file
    test_file = Xapi::TestFile.new(attributes)
    assert_equal attributes[:path], test_file.path
    assert_equal attributes[:files], test_file.files
  end

  def test_text_with_pattern_in_config
    test_file = Xapi::TestFile.new(attributes)
    assert_equal files['a_dog.animal'], test_file.text
  end

  def test_text_with_no_pattern_in_config
    files = {
      "README.md" => "This is a readme",
      "Fakefile" => "Autorun fake code\n",
      "ones_test.tst" => "assert 'one'\n",
    }
    path = './test/fixtures/tracks/fake'
    test_file = Xapi::TestFile.new(path: path, files: files)
    assert_equal files['ones_test.tst'], test_file.text
  end
end
