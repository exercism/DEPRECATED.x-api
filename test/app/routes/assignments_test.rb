require './test/app_helper'
require './test/vcr_helper'

class AppRoutesAssignmentsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_error_on_missing_language
    get '/assignments/unknown/language'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem
    get '/assignments/fake/unknown'

    assert_equal 404, last_response.status
  end

  def test_get_assignments_in_language
    get '/assignments/fruit'
    options = { format: :json, name: 'get_assignments_in_language' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_assignment
    get '/assignments/fake/one'
    options = { format: :json, name: 'get_specific_assignment' }
    Approvals.verify(last_response.body, options)
  end
end
