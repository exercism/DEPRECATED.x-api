module API
  module Helpers
    module Finders
      def find_track(id)
        track = ::Xapi::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        track
      end
    end
  end
end
