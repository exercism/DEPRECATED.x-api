module Xapi
  module Routes
    class Core < Sinatra::Application
      use Bugsnag::Rack

      configure do
        set :root, './lib/app'
        enable :raise_errors
      end

      helpers Helpers::Guards
      helpers Helpers::Errors

      before do
        content_type 'application/json;charset=utf-8'
      end
    end
  end
end
