require './test/v1_helper'

class V1RoutesHomeTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  def test_get_landing_page
    get '/'
    assert_match(/contributing/, last_response.body)
  end
end
