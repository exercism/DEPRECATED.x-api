module Xapi
  module Helpers
    module Errors
      def something_went_wrong
        "Something went wrong, and it's not clear what it was. Please post an issue on GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"
      end

      def forward_errors
        begin
          yield
        rescue Xapi::ApiError => e
          halt 400, {error: e.message}.to_json
        rescue Exception => e
          halt 500, {error: something_went_wrong}.to_json
        end
      end
    end
  end
end
