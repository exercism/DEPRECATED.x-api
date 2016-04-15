require_relative '../test_helper'
require_relative '../../lib/xapi/problem'

class ZipArchiveTest < Minitest::Test
  def assert_files_in_zip(files, zip_file)
    files_in_zip = file_names(zip_file)
    assert_equal files_in_zip.sort, files.sort
  end

  def file_names(zip_file)
    names = []
    Zip::InputStream.open(zip_file) do |io|
      while (entry = io.get_next_entry)
        names << entry.name
      end
    end
    names
  end

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

    assert_files_in_zip ['a_dog.animal', 'a_dog_2.animal'], zip
    zip.unlink
  end

  def test_create_zip_from_folder_recursive
    problem = Xapi::Problem.new(problem_attributes_recursive_files)
    zip = Tempfile.new(['test', '.zip'])
    ZipArchive.write(problem.dir, zip.path)

    expected_files = [
      ".dot", "Fakefile", "one_test.ext", "sub/", "sub/src/", "sub/src/stubfile.ext"
    ]
    assert_files_in_zip expected_files, zip
    zip.unlink
  end
end
