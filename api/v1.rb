$LOAD_PATH << File.expand_path('..', __FILE__)
require 'sinatra/base'
require 'sinatra/petroglyph'
require "bugsnag"
require './config/build_id'
require './config/bugsnag'
require 'v1/routes'
require_relative 'helpers'
require_relative 'services/exercism_io'

module V1
  # API, version 1 and kind of 2. It was a mess.
  class App < Sinatra::Application
    configure do
      enable :raise_errors
      use Rack::Session::Cookie,
          key: 'rack.session',
          path: '/',
          expire_after: 2_592_000,
          secret: ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    not_found do
      halt 404, { error: "endpoint '#{request.path}' not found." }.to_json
    end

    error 500 do
      Bugsnag.auto_notify($ERROR_INFO, nil, request)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    use Routes::Legacy
    use Routes::Home
    use Routes::Tracks
    use Routes::Problems
    use Routes::Exercises
    use Routes::Docs
  end
end
