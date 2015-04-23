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
        all_languages = Xapi::Config.languages # Xapi::Config.all
        

        slugs={}


        all_languages.each do |language|
          track = Xapi::Config.find(language)
          problems = track.problems
          problems.each do |problem|
            if slugs[problem.name].nil?
              slugs[problem.name] = {}
              slugs[problem.name]["languages"] = []
              slugs[problem.name]["name"] = problem.name
              slugs[problem.name]["slug"] = problem.slug
              theYaml = "./metadata/#{problem.slug}.yml"
              slugs[problem.name]["blurb"] = YAML.load(File.read(theYaml))['blurb']
            else
              slugs[problem.name]["languages"].push(language)
            end
          end
          
        end
        slugs.to_json
      end

      get '/wtfwip' do
        # {'helllo' => ''}.to_json
        YAML.load(File.read("./metadata/accumulate.yml"))['blurb'].to_json
      end

#require 'json'
#YAML.load(File.read("./metadata/#{slug}.yml"))
# https://github.com/exercism/x-api/blob/694b387d950b3365ad8f75906b7437ac2c4aea3b/lib/xapi/readme.rb#L49


    end
  end
end



