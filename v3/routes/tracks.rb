module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: config.tracks }
      end

      get '/tracks/:id' do |id|
        track = config.find(id)
        status 404 unless track.implemented?
        pg :track, locals: { track: track }
      end

      get '/tracks/:id/problems' do |id|
        track = config.find(id)
        pg :"track/problems", locals: { track: track }
      end

      get '/tracks/:id/todo' do |id|
        track = config.find(id)
        pg :"track/todos", locals: { track_id: id, todos: track.todo_details }
      end

      get '/tracks/:id/docs/img/:filename' do |id, filename|
        track = config.find(id)
        halt 404 unless track.implemented?
        docs = track.docs
        halt 404 unless docs.exists?
        image = docs.image(filename)
        if image.exists?
          send_file image.path, type: image.type
        else
          halt 404, { error: 'Not found' }.to_json
        end
      end

      get '/tracks/:id/exercises/:slug/readme' do |id, slug|
        track = config.find(id)
        unless track.exists?
          halt 404, { error: "No track %s" % id }.to_json
        end

        problem = track.find(slug)
        unless problem.exists?
          halt 404, {
            error: "Problem %s is not implemented in track '%s'" % [slug, id],
          }.to_json
        end

        pg :"exercise/readme", locals: { problem: problem }
      end

      get '/tracks/:id/exercises/:slug/tests' do |id, slug|
        track = config.find(id)
        unless track.exists?
          halt 404, { error: "No track %s" % id }.to_json
        end

        problem = track.find(slug)
        unless problem.exists?
          halt 404, {
            error: "Problem %s is not implemented in track '%s'" % [slug, id],
          }.to_json
        end

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
