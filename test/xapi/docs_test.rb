require './test/test_helper'
require 'xapi/docs'
require 'xapi/null_docs'

class DocsTest < Minitest::Test
  def test_content
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
    docs = Xapi::Docs.new(non_existent_path)

    assert docs.content.all? { |_doc_name, doc_content| doc_content == "" }
  end

  def test_available
    docs = Xapi::Docs.new(path)

    assert docs.available?
  end

  def test_available_for_non_existent_path
    docs = Xapi::Docs.new(non_existent_path)

    refute docs.available?
  end

  def test_available_for_null_docs
    docs = Xapi::NullDocs.new

    refute docs.available?
  end

  def test_content_for_null_docs
    docs = Xapi::NullDocs.new
    expected_content = {
      "hello" => "",
      "about" => "",
      "resources" => "",
      "tools" => "",
      "workflow" => "",
      "installation" => "",
    }

    assert_equal expected_content, docs.content
  end

  private

  def non_existent_path
    './test/fixtures/problems/non_existent_fake'
  end

  def path
    './test/fixtures/problems/fake'
  end
end
