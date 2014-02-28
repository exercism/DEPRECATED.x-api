module Xapi
  module Routes
    class Demo < Sinatra::Application
      configure do
        set :root, './lib/app'
      end

      get '/demo' do
        pg :exercises, locals: {exercises: Xapi::Demo.exercises}
      end
    end
  end
end
