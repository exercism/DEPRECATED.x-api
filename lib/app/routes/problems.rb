module Xapi
  module Routes
    class Problems < Core
      get '/problems/demo' do
        pg :problems, locals: {problems: Xapi::Demo.problems}
      end

      get '/problems/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :problems, locals: {problems: track.problems}
      end

      get '/problems/:language/:slug' do |language, slug|
        track = Xapi::Config.track_in(language)
        if track.nil?
          halt 404, {error: "no track found '#{language}'"}.to_json
        end
        problem = track.find(slug)
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :problem, locals: {problem: problem}
      end
    end
  end
end
