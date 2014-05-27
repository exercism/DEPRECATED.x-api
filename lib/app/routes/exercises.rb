module Xapi
  module Routes
    class Exercises < Core
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

      # Deprecate this endpoint, forward to the new one.
      get '/exercises/:language/:slug' do |language, slug|
        redirect File.join('/', 'problems', language, slug)
      end
    end
  end
end
