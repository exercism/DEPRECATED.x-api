require './test/app_helper'
require './test/vcr_helper'

class AppRoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_protected_endpoints
    [
      '/exercises/ruby',
      '/exercises',
      '/exercises/restore'
    ].each do |endpoint|
      get endpoint
      assert_equal 401, last_response.status, "GET #{endpoint} should be protected"
    end
  end

  # Acceptance tests. Relies on real language-specific data.
  # Expect it to fail regularly, since exercises get updated fairly frequently.

  def test_get_problems_by_language
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/exercises/ruby', :key => 'abc123'
      options = {:format => :json, :name => 'get_current_problems_by_language'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_get_problems
    VCR.use_cassette('exercism_api_current_exercises') do
      get '/exercises', :key => 'abc123'

      options = {:format => :json, :name => 'get_current_problems'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_restore_exercises_and_solutions
    VCR.use_cassette('exercism_api_restore') do
      get '/exercises/restore', :key => 'abc123'
      options = {:format => :json, :name => 'restore'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_api_error
    VCR.use_cassette('exercism_api_error') do
      get '/exercises', :key => 'no-such-key'
      options = {:format => :json, :name => 'error'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_some_other_error
    error = Proc.new { raise Exception.new("failing hard") }

    Xapi::ExercismIO.stub(:request, error) do
      get '/exercises', :key => 'who-cares'
      options = {:format => :json, :name => '500-error'}
      Approvals.verify(last_response.body, options)
    end
  end
end
