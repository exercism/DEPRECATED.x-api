require './test/test_helper'
require 'xapi/track/image'

class ImageTest < Minitest::Test
  def test_image
    path  = './test/fixtures/tracks/fake/docs'
    image = Xapi::Image.new('test.png', path)
    image_2 = Xapi::Image.new('no_exists.png', path)

    assert_equal true, image.exists?
    assert_equal :png, image.type
    assert_equal './test/fixtures/tracks/fake/docs/img/test.png', image.path
    assert_equal false, image_2.exists?
  end
end
