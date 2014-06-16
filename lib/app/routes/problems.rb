module Xapi
  module Routes
    class Problems < Core
      get '/problems/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :problems, locals: {problems: track.problems}
      end

      get '/problems/:language/:slug' do |language, slug|
        problem = Problem.new(language, slug, 'fresh', '.')
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :problem, locals: {problem: problem}
      end
    end
  end
end
