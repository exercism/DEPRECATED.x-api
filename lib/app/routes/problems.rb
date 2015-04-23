require 'json'
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
        directory = Xapi::Metadata.load.directory
        Xapi::Config.languages.each do |language|
          Xapi::Config.find(language).problems.each do |problem|
            directory[problem.slug].append(problem.track_id)
          end
        end
        pg :summaries, locals: { summaries: directory.values.sort_by(&:slug) }
      end
    end
  end
end
