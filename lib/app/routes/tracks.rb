module Xapi
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: Xapi::Config.tracks }
      end

      get '/tracks/:id' do |id|
        pg :track, locals: { track: Xapi::Config.find(id) }
      end
    end
  end
end
