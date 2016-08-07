require './test/v1_helper'

class V1AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  def test_nonexistant_endpoint
    get '/nonexistant'
    assert_equal 404, last_response.status
    options = { format: :json, name: 'get_nonexistant' }
    Approvals.verify(last_response.body, options)
  end

  def test_error_500
    # Still need to work out how to trigger this.
    # This is probably trying to test the wrong thing.
    # assert_equal 500, last_response.status
    # options = { format: :json, name: 'error_500' }
    # Approvals.verify(last_response.body, options)
  end
end
