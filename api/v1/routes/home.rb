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

      get '/.well-known/acme-challenge/JHwGfL11srcwjgp4fJvHIwQ8EZzzJ6LRNUG8i2AvT00' do
        "JHwGfL11srcwjgp4fJvHIwQ8EZzzJ6LRNUG8i2AvT00.Q0_BNqHpf4NmKK5vvJwbO4KBimS1tdy9FH6TtJd91io"
      end
    end
  end
end
