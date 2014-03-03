module Xapi
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/app'
      end

      helpers Helpers::Guards
    end
  end
end
