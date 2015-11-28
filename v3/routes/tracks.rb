module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: config.tracks }
      end

      get '/tracks/:id' do |id|
        pg :track, locals: { track: config.find(id) }
      end
    end
  end
end
