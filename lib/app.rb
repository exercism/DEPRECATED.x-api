require 'sinatra/base'
require 'sinatra/petroglyph'
require 'haml'
require 'app/routes'
require 'app/helpers'

module Xapi
  class App < Sinatra::Application
    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    use Routes::Home
    use Routes::Demo
    use Routes::Tracks
    use Routes::Exercises
    use Routes::User
  end
end
