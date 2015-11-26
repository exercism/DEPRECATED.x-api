$LOAD_PATH << File.expand_path('..', __FILE__)
require 'sinatra/base'
require 'sinatra/petroglyph'
require "bugsnag"
require './config/build_id'
require './config/bugsnag'
require 'v3/routes'

module V3
  # API, version 3.
  class App < Sinatra::Application
    configure do
      enable :raise_errors
    end

    not_found do
      halt 404, { error: "endpoint '#{request.path}' not found." }.to_json
    end

    error 500 do
      Bugsnag.auto_notify($ERROR_INFO, nil, request)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    use Routes::Tracks
    use Routes::Exercises
  end
end
