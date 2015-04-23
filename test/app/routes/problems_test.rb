require './test/app_helper'
require './test/vcr_helper'

class AppRoutesProblemsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_error_on_missing_language
    get '/problems/unknown/language'

    assert_equal 404, last_response.status
  end

  def test_error_on_missing_language_with_readme
    get '/problems/unknown/language/readme'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem
    get '/problems/ruby/unknown'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_problem_with_readme
    get '/problems/ruby/unknown/readme'

    assert_equal 404, last_response.status
  end

  def test_get_problems_in_language
    get '/problems/php'
    options = { format: :json, name: 'get_problems_in_language' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem
    get '/problems/ruby/leap'
    options = { format: :json, name: 'get_specific_problem' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_readme
    get '/problems/ruby/leap/readme'

    options = { format: :json, name: 'get_specific_problem_readme' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_problem_tests
    get '/problems/ruby/leap/tests'
    options = { format: :json, name: 'get_specific_problem_tests' }
    Approvals.verify(last_response.body, options)
  end

  def test_full_problems_list
    get '/problems'
    options = { format: :json, name: 'get_full_problems_list' }
    Approvals.verify(last_response.body, options)
  end
end
