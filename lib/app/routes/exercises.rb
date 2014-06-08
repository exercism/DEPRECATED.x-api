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
    end
  end
end
