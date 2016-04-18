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

      def find_track_and_implementation(track_id, slug)
        track = find_track(track_id)
        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, track.id],
          }.to_json
        end
        [track, implementation]
      end

      def find_implementation(track_id, slug)
        find_track_and_implementation(track_id, slug).last
      end
    end
  end
end
