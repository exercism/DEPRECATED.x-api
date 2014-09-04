module Xapi
  module Routes
    # deprecated
    class Assignments < Core
      get '/assignments/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :assignments, locals: {assignments: track.problems}
      end

      get '/assignments/:language/:slug' do |language, slug|
        track = Xapi::Config.track_in(language)
        if track.nil?
          halt 404, {error: "no track found '#{language}'"}.to_json
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
