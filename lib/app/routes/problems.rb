module Xapi
  module Routes
    class Problems < Core
      get '/problems/demo' do
        pg :problems, locals: { problems: Xapi::Demo.problems }
      end

      get '/problems/:track' do |id|
        track = Xapi::Config.find(id)
        pg :problems, locals: { problems: track.problems }
      end

      get '/problems/:track/:slug' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem, locals: { problem: problem }
      end

      get '/problems/:track/:slug/readme' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem_readme, locals: { problem: problem }
      end

      get '/problems/:track/:slug/tests' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem_test, locals: { problem: problem }
      end

      get '/problems' do
        all_languages = Xapi::Config.languages # Xapi::Config.all
        slugs={}
        all_languages.each do |language|
          track = Xapi::Config.find(language)
          problems = track.problems
          problems.each do |problem|
            if slugs[problem.name].nil?
              slugs[problem.name] = []
            else
              slugs[problem.name].push(language)
            end
          end
          
        end
        slugs.to_json
      end

    end
  end
end



