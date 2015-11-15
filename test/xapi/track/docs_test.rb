require './test/test_helper'
require 'xapi/track/docs'

class DocsTest < Minitest::Test
  def test_content
    path = './test/fixtures/tracks/fake'
    docs = Xapi::Docs.new(path)

    content = {
      "hello" => "Module\n",
      "about" => "Language Information\n",
      "resources" => "Resources\n",
      "installation" => "Installing\n",
      "tools" => "Lint\n",
      "workflow" => "Running\n",
    }
    assert_equal content, docs.content
  end

  def test_content_for_non_existent_path
    path = './test/fixtures/tracks/non_existent_fake'
    docs = Xapi::Docs.new(path)

    assert docs.content.all? { |_, content| content == "" }
  end
end
