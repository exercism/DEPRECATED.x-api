module V1
  module Routes
    class Home < Sinatra::Base
      get '/' do
        {
          "repository" => Xapi::Config::REPO_URL,
          "contributing" => Xapi::Config::CONTRIBUTING_URL,
          "build_id" => BUILD_ID,
        }.to_json
      end
    end
  end
end
