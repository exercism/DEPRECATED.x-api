module Xapi
  module Helpers
    module Errors
      GITHUB_PLEASE = "Please post an issue on GitHub so we can figure it out."

      def status_500
        "%s %s %s/issues" % [
          "Something went wrong.",
          "Please post an issue on GitHub so we can figure out what happened.",
          Config::EXERCISM_URL,
        ]
      end

      def forward_errors
        yield
      rescue Xapi::ApiError => e
        halt 400, { error: e.message }.to_json
      rescue Exception
        halt 500, { error: status_500 }.to_json
      end
    end
  end
end
