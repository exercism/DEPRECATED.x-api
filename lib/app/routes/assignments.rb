module Xapi
  module Routes
    # deprecated
    class Assignments < Core
      get '/assignments/:track' do |id|
        track = Xapi::Config.find(id)
        pg :assignments, locals: {assignments: track.problems}
      end

      get '/assignments/:track/:problem' do |id, slug|
        track = Xapi::Config.find(id)
        if track.nil?
          halt 404, {error: "no track found '#{id}'"}.to_json
        end
        problem = track.find(slug)
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :assignments, locals: {assignments: [problem]}
      end
    end
  end
end
