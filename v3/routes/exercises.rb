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

      get '/tracks/:id/exercises/:slug' do |id, slug|
        problem = config.find(id).find(slug)
        if problem.exists?
          zip = problem.zip
          begin
            send_file zip.path, type: 'application/octet-stream',
                                filename: "#{slug}.zip",
                                disposition: 'attachment'
          rescue
            zip.unlink
          end
        else
          halt 404, { error: problem.error }.to_json
        end
      end
    end
  end
end
