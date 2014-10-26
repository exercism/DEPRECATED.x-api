require './test/test_helper'
require 'ostruct'
require 'yaml'
require 'xapi/problem'
require 'xapi/code'
require 'xapi/readme'
require 'xapi/iteration'
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
        ["README.md", "two.ext", "two_test.test"],
        ["README.md", "apple.ext", "apple_test.test"],
        ["README.md", "banana.ext", "banana_test.test"],
      ]
      assert_equal expected, backup.problems.map {|problem| problem.files.keys.sort }

      assert_equal "// iteration 2 (done)", backup.problems[0].files["two.ext"]
      assert_equal "// iteration 1 (pending)", backup.problems[1].files["apple.ext"]
      assert_equal "// iteration 1 (hibernating)", backup.problems[2].files["banana.ext"]
    end
  end
end
