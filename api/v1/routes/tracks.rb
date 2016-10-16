module V1
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: Trackler.tracks,
          problems: Trackler.problems,
        }
      end

      get '/tracks/:id' do |id|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        pg :track, locals: {
          track: track,
          problems: Trackler.problems,
        }
      end

      get '/tracks/:id/:problem' do |id, slug|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation for %s in track '%s'" % [slug, id],
          }.to_json
        end

        pg :problem, locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/tracks/:id/:problem/readme' do |id, slug|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation for %s in track '%s'" % [slug, id],
          }.to_json
        end

        pg :problem_readme, locals: {
          track: track,
          implementation: implementation,
        }
      end
    end
  end
end
