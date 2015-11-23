require './test/v1_helper'
require './test/vcr_helper'

class V1RoutesProblemsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  def test_full_problems_list
    get '/problems'
    options = { format: :json, name: 'get_full_problems_list' }
    Approvals.verify(last_response.body, options)
  end

  def test_single_problem
    get '/problems/one'
    options = { format: :json, name: 'get_all_leaps' }
    Approvals.verify(last_response.body, options)
  end

  def test_demo_problems_list
    get '/problems/demo'
    options = { format: :json, name: 'get_demo_problems_list' }
    Approvals.verify(last_response.body, options)
  end
end
