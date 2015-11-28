require './test/test_helper'
require 'xapi/track/docs'
require 'xapi/track/null_docs'

class NullDocsTest < Minitest::Test
  def test_null_docs
    docs = Xapi::NullDocs.new

    assert_equal docs.content.keys.sort, Xapi::Docs::TOPICS.sort
    assert docs.content.all? { |_, content| content.empty? }
  end

  def test_null_docs_exists?
    docs = Xapi::NullDocs.new

    assert_equal false, docs.exists?
  end
end
