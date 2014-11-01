module Xapi
  module Routes
    class Home < Sinatra::Base
      get '/' do
        {
          "repository" => Config::REPO_URL,
          "contributing" => Config::CONTRIBUTING_URL,
          "build_id" => BUILD_ID,
        }.to_json
      end
    end
  end
end
