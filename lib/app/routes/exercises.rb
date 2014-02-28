module Xapi
  module Routes
    class Exercises < Core
      get '/exercises/:language/:slug' do |language, slug|
        exercise = Exercise.new(language, slug)
        pg :exercises, locals: {exercises: [exercise]}
      end
    end
  end
end
