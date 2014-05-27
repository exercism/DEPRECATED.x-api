module Xapi
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/app'
      end

      helpers Helpers::Guards
      helpers Helpers::Errors

      before do
        content_type 'application/json;charset=utf-8'
      end
    end
  end
end
