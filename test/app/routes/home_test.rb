require './test/app_helper'

class AppRoutesHomeTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_get_landing_page
    get '/'
    assert_match(/contributing/, last_response.body)
  end
end
