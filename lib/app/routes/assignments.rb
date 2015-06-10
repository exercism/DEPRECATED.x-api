module Xapi
  module Routes
    # deprecated
    class Assignments < Core
      get '/assignments/:track' do |id|
        track = config.find(id)
        pg :assignments, locals: { assignments: track.problems }
      end

      get '/assignments/:track/:problem' do |id, slug|
        problem = config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :assignments, locals: { assignments: [problem] }
      end
    end
  end
end
