require './test/app_helper'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_404
    get '/no-such-app'
    assert_equal 404, last_response.status
    assert_match /not found/i, JSON.parse(last_response.body)['error']
  end
end
