module Xapi
  module Routes
    class Problems < Core
      get '/problems/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :exercises, locals: {exercises: track.problems}
      end

      get '/problems/:language/:slug' do |language, slug|
        problem = Problem.new(language, slug, 'fresh', '.')
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :exercises, locals: {exercises: [problem]}
      end
    end
  end
end
