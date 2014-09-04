module Xapi
  module Routes
    class Problems < Core
      get '/problems/demo' do
        pg :problems, locals: {problems: Xapi::Demo.problems}
      end

      get '/problems/:track' do |id|
        track = Xapi::Config.find(id)
        pg :problems, locals: {problems: track.problems}
      end

      get '/problems/:track/:slug' do |id, slug|
        track = Xapi::Config.find(id)
        if track.nil?
          halt 404, {error: "no track found '#{id}'"}.to_json
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
