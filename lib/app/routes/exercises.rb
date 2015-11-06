module Xapi
  module Routes
    class Exercises < Core
      helpers do
        def homework
          Xapi::Homework.new(params[:key], languages, path)
        end
      end

      get '/v2/exercises' do
        require_key
        problems = forward_errors { homework.problems }
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/restore' do
        require_key
        problems = forward_errors do
          Xapi::Backup.restore(params[:key])
        end
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/:language' do |language|
        language = language.downcase
        require_key
        problems = forward_errors { homework.problems_in(language) }
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/:language/:slug' do |language, slug|
        language, slug = language.downcase, slug.downcase

        # no need to authenticate for this one
        problem = config.find(language).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problems, locals: { problems: [problem] }
      end
    end
  end
end
