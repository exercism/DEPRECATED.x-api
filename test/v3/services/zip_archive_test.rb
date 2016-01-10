require './lib/xapi/problem'
require './test/v3_helper'

class ZipArchiveTest < Minitest::Test
  def problem_attributes_recursive_files
    {
      track_id: 'fake',
      language: 'Who Cares',
      slug: 'one',
      path: './test/fixtures',
    }
  end

  def problem_attributes_simple_folder
    {
      track_id: 'animal',
      language: 'Who Cares',
      slug: 'dog',
      path: './test/fixtures',
    }
  end

  def test_create_zip_file_from_folder
    problem = Xapi::Problem.new(problem_attributes_simple_folder)
    zip = Tempfile.new(['test', '.zip'])
    ZipArchive.write(problem.dir, zip.path)

    assert_files_in_zip ['a_dog.animal', 'a_dog_2.animal', 'example.ext'], zip
    zip.unlink
  end

  def test_create_zip_from_folder_recursive
    problem = Xapi::Problem.new(problem_attributes_recursive_files)
    zip = Tempfile.new(['test', '.zip'])
    ZipArchive.write(problem.dir, zip.path)

    expected_files = [
      ".dot", "example.ext", "Fakefile", "one_test.tst", "sub/", "sub/src/",
      "sub/src/ExampleFile.ext"
    ]
    assert_files_in_zip expected_files, zip
    zip.unlink
  end
end
