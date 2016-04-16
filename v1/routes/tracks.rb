module V1
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: config.tracks }
      end

      get '/tracks/:id' do |id|
        pg :track, locals: { track: find_track(id) }
      end

      get '/tracks/:id/:problem' do |id, slug|
        problem = config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem, locals: { problem: problem }
      end

      get '/tracks/:id/:problem/readme' do |id, slug|
        problem = config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem_readme, locals: { problem: problem }
      end

      private

      def find_track(id)
        track = config.find(id)
        if track.is_a?(Xapi::NullTrack)
          halt 404, { error: "Track #{id} not found." }.to_json
        end
        track
      end
    end
  end
end
