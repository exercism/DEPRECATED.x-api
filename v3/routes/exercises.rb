module V3
  module Routes
    class Exercises < Core
      get '/tracks/:id/exercises/:slug/readme' do |id, slug|
        problem = config.find(id).find(slug)
        status 404 unless problem.exists?
        pg :"exercise/readme", locals: { problem: problem }
      end

      get '/tracks/:id/exercises/:slug/tests' do |id, slug|
        problem = config.find(id).find(slug)
        status 404 unless problem.exists?
        pg :"exercise/tests", locals: { problem: problem }
      end

      get '/tracks/:id/exercises/:slug/exists' do |id, slug|
        problem = config.find(id).find(slug)
        status 404 unless problem.exists?
        pg :"exercise/exists", locals: { problem: problem }
      end
    end
  end
end
