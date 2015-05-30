require './test/test_helper'
require 'xapi/metadata'

class MetadataTest < Minitest::Test
  def test_all
    metadata = Xapi::Metadata.load("./test/fixtures")
    slugs = %w(apple banana cherry dog one two three).sort
    assert_equal slugs, metadata.summaries.map(&:slug).sort
    assert_equal slugs, metadata.slugs.sort
  end
end
