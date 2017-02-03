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

      get '/.well-known/acme-challenge/Qzooxyz6ib8Ohy8IccdhlKK0QK29SrD5_hQKf-Ay1rg' do
        "Qzooxyz6ib8Ohy8IccdhlKK0QK29SrD5_hQKf-Ay1rg.Q0_BNqHpf4NmKK5vvJwbO4KBimS1tdy9FH6TtJd91io"
      end
    end
  end
end
