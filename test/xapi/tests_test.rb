require './test/test_helper'
require 'json'
require 'xapi/tests'

class TestsTest < Minitest::Test
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
    test_file = Xapi::Tests.new(attributes)
    assert_equal attributes[:path], test_file.path
    expected = { "a_dog.animal" => "assert 'woof woof'\n" }
    assert_equal expected, test_file.test_files
  end

  def test_text_with_pattern_in_config
    test_file = Xapi::Tests.new(attributes)
    expected = { "a_dog.animal" => "assert 'woof woof'\n" }
    assert_equal expected, test_file.test_files
  end

  def test_text_with_no_pattern_in_config
    files = {
      "README.md" => "This is a readme",
      "Fakefile" => "Autorun fake code\n",
      "ones_test.tst" => "assert 'one'\n",
    }
    path = './test/fixtures/tracks/fake'
    test_file = Xapi::Tests.new(path: path, files: files)
    expected = { "ones_test.tst" => "assert 'one'\n" }
    assert_equal expected, test_file.test_files
  end

  def test_text_with_multiple_files
    files = {
      "README.md" => "This is a readme",
      "Fakefile" => "Autorun fake code\n",
      "ones_test.tst" => "assert 'one'\n",
      "two_test.tst" => "assert 'two'\n",
    }
    path = './test/fixtures/tracks/fake'
    test_file = Xapi::Tests.new(path: path, files: files)
    expected = {
      'ones_test.tst' => "assert 'one'\n",
      'two_test.tst' => "assert 'two'\n",
    }
    assert_equal expected, test_file.test_files
  end
end
