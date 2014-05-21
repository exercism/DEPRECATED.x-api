module Xapi
  module Routes
    class Exercises < Core
      get '/exercises/:language/:slug' do |language, slug|
        exercise = Problem.new(language, slug, 'fresh', '.')
        if exercise.not_found?
          halt 404, {error: exercise.error_message}.to_json
        end
        pg :exercises, locals: {exercises: [exercise]}
      end

      # see lib/app/routes/user.rb for the (authenticated)
      # /exercises and /exercises/:language endpoints
    end
  end
end
