module V1
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: Trackler.tracks,
          todos: Trackler.todos,
        }
      end

      get '/tracks/:id' do |id|
        track = find_track(id)
        pg :track, locals: {
          track: track,
          todos: Trackler.todos,
        }
      end
    end
  end
end
