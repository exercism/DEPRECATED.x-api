module Xapi
  module Routes
    class Demo < Sinatra::Application
      get '/demo' do
        "DEMO ME"
      end
    end
  end
end
