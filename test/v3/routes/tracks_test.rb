require './test/v3_helper'
require './test/vcr_helper'

class V3RoutesTracksTest < Minitest::Test
  include Rack::Test::Methods

  def app
    V3::App
  end

  def test_tracks
    get '/tracks'

    tracks = JSON.parse(last_response.body)["tracks"]
    expected = %w(animal fake fruit jewels)
    assert_equal expected, tracks.map { |track| track["id"] }.sort

    get '/tracks/fake'

    fake1 = tracks.find { |track| track["id"] == "fake" }
    fake2 = JSON.parse(last_response.body)["track"]
    assert_equal fake1, fake2

    Approvals.verify(fake2, name: 'v3_track')

    get '/tracks/blueberry'
    assert_equal 404, last_response.status
    body = JSON.parse(last_response.body)
    Approvals.verify(body, name: 'v3_track_unimplemented')
  end

  def test_problems
    get '/tracks/fake/problems'
    fake = JSON.parse(last_response.body)["track"]
    assert_equal fake.keys.sort, %w(id language problems)
    Approvals.verify(fake["problems"], name: 'v3_track_problems')
  end

  def test_todos
    get '/tracks/fake/todo'
    fake = JSON.parse(last_response.body)
    Approvals.verify(fake["todos"], name: 'v3_track_todo')
  end

  def test_images
    get '/tracks/fake/docs/img/test.png'

    assert_equal last_response.headers["Content-Type"], 'image/png'
    Approvals.verify(last_response.body, name: 'valid_image_png')

    get '/tracks/fake/docs/img/test.jpg'

    assert_equal last_response.headers["Content-Type"], 'image/jpeg'
    Approvals.verify(last_response.body, name: 'valid_image_jpg')

    get '/tracks/no_exists/docs/img/ghost.png'
    assert_equal 404, last_response.status

    get '/tracks/animal/docs/img/no_content.png'
    assert_equal 404, last_response.status

    get '/tracks/fake/docs/img/not_found.png'
    assert_equal last_response.headers["Content-Type"], 'application/json;charset=utf-8'
    not_found = JSON.parse(last_response.body)
    Approvals.verify(not_found, name: 'not_found_image')
  end
end
