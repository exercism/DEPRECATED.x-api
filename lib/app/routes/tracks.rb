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

      get '/tracks/:id/:problem' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem, locals: { problem: problem }
      end

      get '/tracks/:id/:problem/readme' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem_readme, locals: { problem: problem }
      end

      get '/tracks/:id/:problem/tests' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem_test, locals: { problem: problem }
      end
    end
  end
end
