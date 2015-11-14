require './test/v1_helper'

class V1RoutesHomeTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::V1
  end

  def test_get_landing_page
    get '/'
    assert_match(/contributing/, last_response.body)
  end
end
