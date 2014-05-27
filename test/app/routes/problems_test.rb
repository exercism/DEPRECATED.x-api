require './test/app_helper'
require './test/vcr_helper'

class AppRoutesProblemsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_get_problems_in_language
    get '/problems/php'
    options = {:format => :json, :name => 'get_problems_in_language'}
    Approvals.verify(last_response.body, options)
  end
end
