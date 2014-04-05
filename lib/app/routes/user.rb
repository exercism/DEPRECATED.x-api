module Xapi
  module Routes
    class User < Core
      before do
        require_key
      end

      get '/exercises' do
        pg :exercises, locals: {exercises: Xapi::Homework.new(params[:key]).exercises}
      end

      get '/exercises/restore' do
        pg :exercises, locals: {exercises: Xapi::Backup.restore(params[:key])}
      end

      get '/exercises/:language' do |language|
        pg :exercises, locals: {exercises: Xapi::Homework.new(params[:key]).exercises_in(language)}
      end
    end
  end
end
