module Xapi
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {tracks: Xapi::Config.tracks}
      end

      get '/tracks/:slug' do |slug|
        pg :track, locals: {track: Xapi::Config.track_in(slug)}
      end
    end
  end
end
