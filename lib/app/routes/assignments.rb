module Xapi
  module Routes
    # deprecated
    class Assignments < Core
      get '/assignments/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :assignments, locals: {assignments: track.problems}
      end

      get '/assignments/:language/:slug' do |language, slug|
        problem = Problem.new(language, slug, 'fresh', '.')
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :assignments, locals: {assignments: [problem]}
      end
    end
  end
end
