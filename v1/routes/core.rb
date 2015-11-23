module V1
  module Routes
    class Core < Sinatra::Application
      use Bugsnag::Rack

      configure do
        set :root, "./v1"
        enable :raise_errors
      end

      configure :development, :production do
        set :config, Xapi::Config.new
      end

      configure :test do
        set :config, Xapi::Config.new("./test/fixtures")
      end

      helpers Helpers::Guards
      helpers Helpers::Errors
      helpers Helpers::Config

      before do
        content_type 'application/json', charset: 'utf-8'
      end
    end
  end
end
