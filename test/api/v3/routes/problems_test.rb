require './test/v3_helper'
require './test/vcr_helper'

class V3RoutesProblemsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V3::App
  end

  def test_todos
    get '/problems/hello-world/todo'
    body = JSON.parse(last_response.body)
    Approvals.verify(body["problem"], name: 'v3_problem_todo')
  end

  def test_jsons
    get '/problems/data-todos'
    body = JSON.parse(last_response.body)
    Approvals.verify(body["problems"], name: 'v3_problems_shared_data')
  end
end
