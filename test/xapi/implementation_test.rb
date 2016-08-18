require_relative '../test_helper'
require 'xapi/problem'
require 'xapi/implementation'

class ImplementationTest < Minitest::Test
  PATH     = FIXTURE_PATH
  TRACK_ID = 'fake'.freeze
  URL      = '[URL]'.freeze
  PROBLEM  = Xapi::Problem.new('hello-world', PATH)

  def test_zip
    implementation = Xapi::Implementation.new(TRACK_ID, URL, PROBLEM, PATH)
    # Our archive is not binary identically reproducable :(
    archive = implementation.zip
    assert_instance_of StringIO, archive
    expected_files = ['hello_test.ext', 'world_test.ext', 'README.md']
    assert_equal expected_files, archive_filenames(implementation.zip)
  end

  def test_implementation_with_extra_files
    problem = Xapi::Problem.new('one', PATH)
    implementation = Xapi::Implementation.new(TRACK_ID, URL, problem, PATH)
    # implementation_one_files.approved.txt has:
    #   implementation specific hint in README (but not language-specific hint)
    #   includes dotfiles and files in subdirectories
    Approvals.verify(implementation.files, name: 'implementation_one_files')
  end

  def test_implementation_in_subdirectory
    problem = Xapi::Problem.new('apple', PATH)
    implementation = Xapi::Implementation.new('fruit', URL, problem, PATH)
    assert_equal "[URL]/tree/master/exercises/apple", implementation.git_url
    assert_match Regexp.new('exercises[\\/]apple'), implementation.exercise_dir
    Approvals.verify(implementation.files, name: 'implementation_apple_files')
  end

  def test_language_and_implementation_specific_readme
    problem = Xapi::Problem.new('banana', PATH)
    implementation = Xapi::Implementation.new('fruit', URL, problem, PATH)
    Approvals.verify(implementation.readme, name: 'implementation_banana_readme')
  end

  def test_missing_implementation
    problem = Xapi::Problem.new('apple', PATH)
    implementation = Xapi::Implementation.new(TRACK_ID, URL, problem, PATH)
    refute implementation.exists?, "Not expecting apple to be implemented for track TRACK_ID"
  end

  def test_override_implementation_files
    implementation = Xapi::Implementation.new(TRACK_ID, URL, PROBLEM, PATH)
    files = { "filename" => "contents" }
    implementation.files = files
    assert_equal files, implementation.files
  end

  private

  def archive_filenames(zip)
    files = []
    Zip::InputStream.open(zip) do |io|
      while (entry = io.get_next_entry)
        files << entry.name
      end
    end
    files
  end
end
