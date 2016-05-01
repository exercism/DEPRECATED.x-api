$LOAD_PATH << File.expand_path('..', __FILE__)
require 'sinatra/base'
require 'sinatra/petroglyph'
require "bugsnag"
require './config/build_id'
require './config/bugsnag'
require 'v3/routes'
require_relative 'helpers'

# V3 is the 3rd version of the API.
# The CLI is currently using v1.
# There is no v2 because v1 contains some weird v2 endpoints.
module V3
  # API, version 3.
  class App < Sinatra::Application
    configure do
      enable :raise_errors
      set :protection, except: [:json_csrf]
    end

    not_found do
      halt 404, { error: "endpoint '#{request.path}' not found." }.to_json
    end

    error 500 do
      Bugsnag.auto_notify($ERROR_INFO, nil, request)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    use Routes::Problems
    use Routes::Tracks
  end
end
