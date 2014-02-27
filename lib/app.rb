require 'app/routes'

module Xapi
  class App < Sinatra::Application
    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
      set :root, File.expand_path('../', __FILE__)
    end

    use Routes::Demo
  end
end
