module V3
  module Routes
    class Exercises < Core
      get '/tracks/:id/exercises/:slug/readme' do |id, slug|
        problem = config.find(id).find(slug)
        pg :"exercise/readme", locals: { problem: problem }
      end
    end
  end
end
