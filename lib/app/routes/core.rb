module Xapi
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/app'
      end
    end
  end
end
