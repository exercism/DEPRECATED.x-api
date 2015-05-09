require 'sinatra/base'
require 'sinatra/petroglyph'
require "bugsnag"
require './config/build_id'
require 'app/routes'
require 'app/helpers'

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.project_root = File.expand_path("../..", __FILE__)
  config.notify_release_stages = %w(production development)
end

module Xapi
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
      Bugsnag.auto_notify($ERROR_INFO)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    use Routes::Home
    use Routes::Tracks
    use Routes::Problems
    use Routes::Assignments # deprecated: CLI and prototype use it
    use Routes::Exercises
    use Routes::Docs
  end
end
