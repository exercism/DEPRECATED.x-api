module Xapi
  module Routes
    class Home < Sinatra::Base
      get '/' do
        {
          "repository" => "https://github.com/exercism/x-api",
          "contributing" => "https://github.com/exercism/x-api/blob/master/CONTRIBUTING.md"
        }.to_json
      end
    end
  end
end
