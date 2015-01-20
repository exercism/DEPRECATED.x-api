module Xapi
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: Xapi::Config.tracks }
      end

      get '/tracks/:id' do |id|
        track = Xapi::Config.find(id)
        if track.is_a?(NullTrack)
          halt 404, { error: "Track #{id} not found." }.to_json
        end
        pg :track, locals: { track: track }
      end
    end
  end
end
