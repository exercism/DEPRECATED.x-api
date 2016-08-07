require './test/v1_helper'

class V1RoutesLegacyTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V1::App
  end

  def test_get_exercises
    get '/exercises'
    assert_equal 500, last_response.status
    options = { format: :text, name: 'v1_get_exercises' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_restore
    get '/exercises/restore'
    assert_equal 500, last_response.status
    options = { format: :text, name: 'v1_get_exercises_restore' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_language
    get '/exercises/language'
    assert_equal 500, last_response.status
    options = { format: :text, name: 'v1_get_exercises_language' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_problems_demo
    get '/problems/demo'
    assert_equal 404, last_response.status
    options = { format: :text, name: 'v1_get_problems_demo' }
    Approvals.verify(last_response.body, options)
  end
end
