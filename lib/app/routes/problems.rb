require 'json'
module Xapi
  module Routes
    class Problems < Core
      # This is special.
      # There is no problem called 'demo',
      # and perhaps this really should be just plain
      # /demo at the root of the app.
      get '/problems/demo' do
        pg :problems, locals: { problems: Xapi::Demo.problems }
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

      # v1: brute force
      get '/problems/:slug' do |slug|
        directory = Xapi::Metadata.load.directory
        unless directory[slug]
          halt 404, { error: "Unknown problem '#{slug}'" }.to_json
        end
        Xapi::Config.languages.each do |language|
          Xapi::Config.find(language).problems.each do |problem|
            directory[problem.slug].append(problem.track_id)
          end
        end
        pg :summary, locals: { summary: directory[slug] }
      end
    end
  end
end
