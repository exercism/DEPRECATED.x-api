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

      get '/tracks/:id/:problem' do |id, slug|
        track, implementation = find_track_and_implementation(id, slug)
        pg :problem, locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/tracks/:id/:problem/readme' do |id, slug|
        track, implementation = find_track_and_implementation(id, slug)
        pg :problem_readme, locals: {
          track: track,
          implementation: implementation,
        }
      end
    end
  end
end
