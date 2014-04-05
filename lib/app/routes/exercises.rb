module Xapi
  module Routes
    class Exercises < Core
      get '/exercises' do
        require_key
        pg :exercises, locals: {exercises: Xapi::Homework.new(params[:key]).exercises}
      end

      get '/exercises/restore' do
        require_key
        pg :exercises, locals: {exercises: Xapi::Backup.restore(params[:key])}
      end

      get '/exercises/:language' do |language|
        require_key
        pg :exercises, locals: {exercises: Xapi::Homework.new(params[:key]).exercises_in(language)}
      end

      get '/exercises/:language/:slug' do |language, slug|
        exercise = Exercise.new(language, slug)
        if exercise.not_found?
          halt 404, {error: exercise.error_message}.to_json
        end
        pg :exercises, locals: {exercises: [exercise]}
      end
    end
  end
end
