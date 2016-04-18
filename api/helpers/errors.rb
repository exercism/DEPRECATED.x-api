module API
  module Helpers
    module Errors
      GITHUB_PLEASE = "Please post an issue on GitHub so we can figure it out."

      def friendly_500
        {
          error: "%s %s %s/issues" % [
            "Something went wrong.",
            GITHUB_PLEASE,
            ::Xapi::EXERCISM_URL,
          ],
        }.to_json
      end

      def verbose_500(e)
        {
          error: e.message.squeeze("\n").split("\n"),
          backtrace: e.backtrace,
        }.to_json
      end

      def forward_errors
        yield
      rescue Xapi::ApiError => e
        halt 400, { error: e.message }.to_json
      rescue Exception => e
        if %w(test development).include?(ENV['RACK_ENV'].to_s)
          halt 500, verbose_500(e)
        end
        Bugsnag.notify(e, nil, request)
        halt 500, friendly_500
      end
    end
  end
end
