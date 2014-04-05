module Xapi
  module Routes
    class Exercises < Core
      helpers do
        def render_homework(method, *args)
          require_key
          pg :exercises, locals: {exercises: Xapi::Homework.send(method, params[:key], *args)}
        end
      end

      get '/exercises' do
        render_homework(:exercises_for)
      end

      get '/exercises/restore' do
        render_homework(:restore)
      end

      get '/exercises/:language' do |language|
        render_homework(:all_exercises_by_language_for, language)
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
