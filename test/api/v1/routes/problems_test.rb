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
    assert_equal 200, last_response.status
    Approvals.verify(last_response.body, options)
  end

  def test_single_problem
    get '/problems/one'
    options = { format: :json, name: 'get_problems_one' }
    assert_equal 200, last_response.status
    Approvals.verify(last_response.body, options)
  end


  def test_nonexistant_problem
    get '/problems/nonexistant'
    options = { format: :json, name: 'get_problems_nonexistant' }
    assert_equal 404, last_response.status
    Approvals.verify(last_response.body, options)
  end

end
