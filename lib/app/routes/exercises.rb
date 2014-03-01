module Xapi
  module Routes
    class Exercises < Core
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
