require './test/test_helper'
require 'ostruct'
require 'yaml'
require 'xapi/problem'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/lesson'
require 'xapi/iteration'
require 'xapi/course'
require 'xapi/backup'

class BackupTest < Minitest::Test
  def test_zip_together_code_and_problems
    backup = Xapi::Backup.new('abc123', './test/fixtures')
    data = [
      {"slug" => "two", "track" => "fake", "files" => {"two.ext" => "// iteration 2 (done)"}},
      {"slug" => "apple", "track" => "fruit", "files" => {"apple.ext" => "// iteration 1 (pending)"}},
      {"slug" => "banana", "track" => "fruit", "files" => {"banana.ext" => "// iteration 1 (hibernating)"}}
    ]
    backup.stub(:data, data) do
      expected = [
        ["two.ext", "two_test.test", "README.md"],
        ["apple.ext", "apple_test.test", "README.md"],
        ["banana.ext", "banana_test.test", "README.md"]
      ]
      assert_equal expected, backup.problems.map {|problem| problem.files.keys }
    end
  end
end
