require './test/test_helper'
require 'xapi/metadata'

class MetadataTest < Minitest::Test
  def test_all
    metadata = Xapi::Metadata.load("./test/fixtures/metadata")
    slugs = %w(apple banana dog one two).sort
    assert_equal slugs, metadata.summaries.map(&:slug)
  end
end
