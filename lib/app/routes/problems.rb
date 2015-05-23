require 'json'
module Xapi
  module Routes
    class Problems < Core
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
    end
  end
end
