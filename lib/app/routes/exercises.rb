module Xapi
  module Routes
    class Exercises < Core
      get '/exercises' do
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems
        end
        pg :assignments, locals: {assignments: problems}
      end

      get '/exercises/restore' do
        require_key
        problems = forward_errors do
          Xapi::Backup.restore(params[:key])
        end
        pg :assignments, locals: {assignments: problems}
      end

      get '/exercises/:language' do |language|
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems_in(language)
        end
        pg :assignments, locals: {assignments: problems}
      end

      get '/v2/exercises' do
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems
        end
        pg :problems, locals: {problems: problems}
      end

      get '/v2/exercises/restore' do
        require_key
        problems = forward_errors do
          Xapi::Backup.restore(params[:key])
        end
        pg :problems, locals: {problems: problems}
      end

      get '/v2/exercises/:language' do |language|
        require_key
        problems = forward_errors do
          Xapi::Homework.new(params[:key]).problems_in(language)
        end
        pg :problems, locals: {problems: problems}
      end

      get '/v2/exercises/:language/:slug' do |language, slug|
        # no need to authenticate for this one
        track = Xapi::Config.find(language)
        if track.nil?
          halt 404, {error: "no track found '#{language}'"}.to_json
        end
        problem = track.find(slug)
        if problem.not_found?
          halt 404, {error: problem.error_message}.to_json
        end
        pg :problems, locals: {problems: [problem]}
      end
    end
  end
end
