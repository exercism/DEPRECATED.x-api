require './test/app_helper'

class AppRoutesDemoTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_get_demo_exercises
    get '/demo'
    options = {:format => :json, :name => 'get_demo_exercises'}
    Approvals.verify(last_response.body, options)
  end
end
