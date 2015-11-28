require './test/test_helper'
require 'xapi/track/docs'
require 'xapi/track/image'

class DocsTest < Minitest::Test
  def test_content
    path = './test/fixtures/tracks/fake'
    docs = Xapi::Docs.new(path)

    content = {
      "about" => "Language Information\n",
      "installation" => "Installing\n",
      "tests" => "Running\n",
      "learning" => "Learning Fake!\n",
      "resources" => "Resources\n",
    }
    assert_equal content, docs.content
  end

  def test_content_for_non_existent_path
    path = './test/fixtures/tracks/non_existent_fake'
    docs = Xapi::Docs.new(path)

    assert docs.content.all? { |_, content| content == "" }
  end

  def test_image
    path  = './test/fixtures/tracks/fake'
    docs = Xapi::Docs.new(path)

    assert_kind_of Xapi::Image, docs.image('test.png')
  end
end
