require './test/app_helper'
require './test/vcr_helper'

class AppRoutesProblemsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_full_problems_list
    get '/problems'
    options = { format: :json, name: 'get_full_problems_list' }
    Approvals.verify(last_response.body, options)
  end

  def test_single_problem
    get '/problems/leap'
    options = { format: :json, name: 'get_all_leaps' }
    Approvals.verify(last_response.body, options)
  end
end
