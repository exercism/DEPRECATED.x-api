require_relative 'test_helper'
require_relative '../../lib/rewrite/problem'
require_relative '../../lib/rewrite/implementation'

class RewriteImplementationTest < Minitest::Test
  def assert_archive_contains(filenames, zip)
    files = []
    Zip::InputStream.open(zip) do |io|
      while (entry = io.get_next_entry)
        files << entry.name
      end
    end
    assert_equal filenames.sort, files.sort
  end

  def test_implementation
    problem = Rewrite::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Rewrite::Implementation.new('fake', "[URL]", problem, FIXTURE_PATH)

    assert implementation.exists?, "Expecting hello-world problem to be implemented in track 'fake'"
    assert_equal "[URL]/tree/master/hello-world", implementation.git_url

    readme = <<-README
# Hello World

Oh, hello.

* hello
* hello again

## Source

The internet. [http://example.com](http://example.com)
    README

    files = {
      "hello_test.ext" => "assert 'hello'\n",
      "world_test.ext" => "assert 'World'\n",
      "README.md" => readme,
    }
    assert_equal files, implementation.files
    assert_archive_contains files.keys, implementation.zip
    assert_equal "hello-world", implementation.exercise_dir
  end

  # implementation specific hint in README (but not language-specific hint)
  def test_implementation_with_extra_files # including dotfiles and files in subdirectories
    problem = Rewrite::Problem.new('one', FIXTURE_PATH)
    implementation = Rewrite::Implementation.new('fake', "[URL]", problem, FIXTURE_PATH)
    readme = <<-README
# One

This is one.

* one
* one again

* one hint
* one more hint

## Source

The internet. [http://example.com](http://example.com)
    README
    files = {
      ".dot" => "dot\n",
      "Fakefile" => "Autorun fake code\n",
      "one_test.ext" => "assert 'one'\n",
      "sub/src/stubfile.ext" => "stub\n",
      "README.md" => readme,
    }
    assert_equal files, implementation.files
    assert_archive_contains files.keys, implementation.zip
  end

  def test_implementation_in_subdirectory
    problem = Rewrite::Problem.new('apple', FIXTURE_PATH)
    implementation = Rewrite::Implementation.new('fruit', "[URL]", problem, FIXTURE_PATH)
    assert_equal "[URL]/tree/master/exercises/apple", implementation.git_url

    readme = <<-README
# Apple

This is apple.

* apple
* apple again

Do stuff.

## Source

The internet.
    README
    assert_equal readme, implementation.readme
    files = {
      "apple.ext" => "an apple a day keeps the doctor away\n",
      "apple.tst" => "assert 'apple'\n",
      "README.md" => readme,
    }
    assert_match Regexp.new("exercises.apple"), implementation.exercise_dir
    assert_equal files, implementation.files
  end

  def test_language_and_implementation_specific_readme
    problem = Rewrite::Problem.new('banana', FIXTURE_PATH)
    implementation = Rewrite::Implementation.new('fruit', "[URL]", problem, FIXTURE_PATH)
    readme = <<-README
# Banana

This is banana.

* banana
* banana again

Do stuff.

* a hint
* another hint

## Source

[http://example.com](http://example.com)
    README
    assert_equal readme, implementation.readme
  end

  def test_missing_implementation
    problem = Rewrite::Problem.new('apple', FIXTURE_PATH)
    implementation = Rewrite::Implementation.new('fake', "[URL]", problem, FIXTURE_PATH)
    refute implementation.exists?, "Not expecting apple to be implemented for track 'fake'"
  end
end
