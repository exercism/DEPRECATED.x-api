require './test/v3_helper'
require './test/vcr_helper'

class V3RoutesExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V3::App
  end

  def test_readme
    get '/tracks/fake/exercises/three/readme'

    options = { format: :json, name: 'v3_readme' }
    Approvals.verify(last_response.body, options)
  end
end
