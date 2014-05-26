module Xapi
  module Routes
    class Exercises < Core
      def something_went_wrong
        "Something went wrong, and it's not clear what it was. Please post an issue on GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"
      end

      helpers do
        def forward_errors
          begin
            yield
          rescue Xapi::ApiError => e
            halt 400, {error: e.message}.to_json
          rescue Exception => e
            halt 500, {error: something_went_wrong}.to_json
          end
        end
      end

      get '/exercises' do
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems
        end
        pg :exercises, locals: {exercises: problems}
      end

      get '/exercises/restore' do
        require_key
        problems = forward_errors do
          Xapi::Backup.restore(params[:key])
        end
        pg :exercises, locals: {exercises: problems}
      end

      get '/exercises/:language' do |language|
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems_in(language)
        end
        pg :exercises, locals: {exercises: problems}
      end

      get '/exercises/:language/:slug' do |language, slug|
        exercise = Problem.new(language, slug, 'fresh', '.')
        if exercise.not_found?
          halt 404, {error: exercise.error_message}.to_json
        end
        pg :exercises, locals: {exercises: [exercise]}
      end
    end
  end
end
