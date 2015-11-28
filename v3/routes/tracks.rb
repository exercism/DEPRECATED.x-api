module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: config.tracks }
      end

      get '/tracks/:id' do |id|
        track = config.find(id)
        status 404 unless track.implemented?
        pg :track, locals: { track: track }
      end
    end
  end
end
