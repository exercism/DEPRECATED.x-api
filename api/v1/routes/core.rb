module V1
  module Routes
    class Core < Sinatra::Application
      use Bugsnag::Rack

      configure do
        set :root, "./api/v1"
        enable :raise_errors
      end

      configure :development, :production do
        set :tracks_path, "."
      end

      configure :test do
        set :tracks_path, "./test/fixtures"
      end

      helpers ::API::Helpers::Guards
      helpers ::API::Helpers::Errors
      helpers ::API::Helpers::Finders

      before do
        content_type 'application/json', charset: 'utf-8'
      end
    end
  end
end
