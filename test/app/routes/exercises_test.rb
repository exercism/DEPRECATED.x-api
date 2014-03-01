require './test/app_helper'

class AppRoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_error_on_missing_language
    get '/exercises/unknown/language'

    assert_equal 404, last_response.status
  end

  def test_error_on_nonexistent_exercise
    get '/exercises/ruby/unknown'

    assert_equal 404, last_response.status
  end

  def test_get_specific_exercise
    get '/exercises/ruby/leap'
    options = {:format => :json, :name => 'get_specific_exercises'}
    Approvals.verify(last_response.body, options)
  end
end
