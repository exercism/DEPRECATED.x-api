module Xapi
  module Routes
    class Exercises < Core
      get '/exercises' do
        unless params[:key]
          halt 401, {error: "Please provide your Exercism.io API key"}.to_json
        end

        pg :exercises, locals: {exercises: Xapi::UserHomework.exercises_for(params[:key])}
      end

      get '/exercises/:language/:slug' do |language, slug|
        exercise = Exercise.new(language, slug)
        if exercise.unknown_language?
          halt 404, {error: "We don't have exercises in '#{language}'"}.to_json
        elsif exercise.unknown_exercise?
          halt 404, {error: "We don't have '#{slug}' for '#{language}'"}.to_json
        end
        pg :exercises, locals: {exercises: [exercise]}
      end
    end
  end
end
