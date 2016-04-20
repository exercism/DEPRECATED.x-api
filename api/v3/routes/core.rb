module V3
  module Routes
    class Core < Sinatra::Application
      use Bugsnag::Rack

      configure do
        set :root, "./api/v3"
        enable :raise_errors
        set :protection, except: [:json_csrf]
      end

      configure :development, :production do
        set :tracks_path, "."
      end

      configure :test do
        set :tracks_path, "./test/fixtures"
      end

      before do
        content_type 'application/json', charset: 'utf-8'
      end

      helpers ::API::Helpers::Finders
    end
  end
end
