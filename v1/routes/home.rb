module V1
  module Routes
    class Home < Sinatra::Base
      get '/' do
        {
          "repository" => ::Rewrite::REPO_URL,
          "contributing" => ::Rewrite::CONTRIBUTING_URL,
          "build_id" => BUILD_ID,
        }.to_json
      end
    end
  end
end
