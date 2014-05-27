require './test/app_helper'
require './test/vcr_helper'

class AppRoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_deprecated_endpoint
    get '/exercises/ruby/leap'
    assert_equal 302, last_response.status
    assert_equal "http://example.org/problems/ruby/leap", last_response.headers['Location']
  end
end
