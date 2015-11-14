module Xapi
  module Helpers
    module Config
      def config
        settings.config
      end

      def path
        config.path
      end
    end
  end
end
