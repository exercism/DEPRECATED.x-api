module V1
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: ::Xapi.tracks,
          problems: ::Xapi.problems,
        }
      end

      get '/tracks/:id' do |id|
        track = find_track(id)
        pg :track, locals: {
          track: track,
          problems: ::Xapi.problems,
        }
      end

      get '/tracks/:id/:problem' do |id, slug|
        track = find_track(id)

        implementation = track.implementations[slug]
        unless implementation.exists?

          error = if Xapi.problems[slug].exists?
            "Exercise '%s' isn't yet available in %s. Help us fix it by contributing to Exercism! Visit https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md to get started!"
          else
            "Cannot find %s in any of our Exercism tracks!"
          end

          halt 404, {
            error: error % [slug, id],
          }.to_json
        end

        pg :problem, locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/tracks/:id/:problem/readme' do |id, slug|
        track = ::Xapi::Track.new(id, settings.tracks_path)
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
