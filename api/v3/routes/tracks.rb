module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: Trackler.tracks,
          problems: Trackler.problems,
        }
      end

      get '/tracks/:id' do |id|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        pg :track, locals: {
          track: track,
          todo: Trackler.problems - track.slugs,
        }
      end

      get '/tracks/:id/problems' do |id|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        pg :"track/problems", locals: { track: track }
      end

      get '/tracks/:id/todo' do |id|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        slugs = Trackler.problems - track.slugs
        pg :"track/todos", locals: {
          track: track,
          problems: slugs.map { |slug| Trackler.problems[slug] },
          implementations: Trackler.implementations,
        }
      end

      get '/tracks/:id/img/:filename' do |id, filename|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        img = track.img("img/#{filename}").tap do |image|
          image.path = "img/default_icon.png" unless image.exists?
        end

        send_file img.path, type: img.type
      end

      get '/tracks/:id/docs/img/:filename' do |id, filename|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        img = track.img("docs/img/#{filename}")
        unless img.exists?
          halt 404, {
            error: "No image %s in track '%s'" % [filename, id],
          }.to_json
        end

        send_file img.path, type: img.type
      end

      get '/tracks/:id/exercises/:slug' do |id, slug|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, id],
          }.to_json
        end

        filename = "%s-%s.zip" % [id, slug]
        headers['Content-Type'] = "application/octet-stream"
        headers["Content-Disposition"] = "attachment;filename=%s" % filename

        implementation.zip.string
      end

      get '/tracks/:id/global' do |id|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        filename = "%s-%s.zip" % [id, "global"]
        headers['Content-Type'] = "application/octet-stream"
        headers["Content-Disposition"] = "attachment;filename=%s" % filename
        track.global_zip.string
      end

      # :files is either "readme" or "tests".
      get '/tracks/:id/exercises/:slug/:files' do |id, slug, files|
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, id],
          }.to_json
        end

        pg "exercise/#{files}".to_sym, locals: {
          track: track,
          implementation: implementation,
        }
      end
    end
  end
end
