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
        slugs = {}
        Xapi::Config.languages.each do |language|
          Xapi::Config.find(language).problems.each do |problem|
            if slugs[problem.slug].nil?
              slugs[problem.slug] = {}
              slugs[problem.slug]["track_ids"] = []
              slugs[problem.slug]["name"] = problem.name
              slugs[problem.slug]["slug"] = problem.slug
              yml = YAML.load(File.read("./metadata/#{problem.slug}.yml"))
              slugs[problem.slug]["blurb"] = yml['blurb']
            end
            slugs[problem.slug]["track_ids"].push(language)
          end
        end
        { "problems" => slugs.values }.to_json
      end
    end
  end
end
