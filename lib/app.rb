require 'sinatra/base'
require 'sinatra/petroglyph'
require "bugsnag"
require 'haml'
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
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2_592_000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    not_found do
      halt 404, {error: "Endpoint '#{request.path}' not found."}.to_json
    end

    use Routes::Home
    use Routes::Demo
    use Routes::Tracks
    use Routes::Problems
    use Routes::Assignments # deprecated: CLI and prototype use it
    use Routes::Exercises
  end
end
