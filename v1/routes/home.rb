module V1
  module Routes
    class Home < Sinatra::Base
      get '/' do
        {
          "repository" => ::Xapi::REPO_URL,
          "contributing" => ::Xapi::CONTRIBUTING_URL,
          "build_id" => BUILD_ID,
        }.to_json
      end
    end
  end
end
