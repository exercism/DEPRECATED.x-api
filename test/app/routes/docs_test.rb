require './test/app_helper'
require './test/vcr_helper'

class AppRoutesDocsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Xapi::App
  end

  def test_error_on_missing_track
    get '/docs/unknown'

    assert_equal 404, last_response.status
    assert_equal '{"error":"Documentation for track unknown was not found."}', last_response.body
  end

  def test_error_on_missing_documentation
    Xapi::Config.stub(:find, Xapi::Track.new('.')) do
      get '/docs/unknown'

      assert_equal 404, last_response.status
      assert_equal '{"error":"Documentation for track unknown was not found."}', last_response.body
    end
  end

  def test_get_docs_for_language
    get '/docs/csharp'
    options = { format: :json, name: 'get_docs_for_language' }
    Approvals.verify(last_response.body, options)
  end
end
