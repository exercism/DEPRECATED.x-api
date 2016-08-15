module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: ::Xapi.tracks,
          problems: ::Xapi.problems,
        }
      end

      get '/tracks/:id' do |id|
        track = find_track(id)
        pg :track, locals: {
          track: track,
          todo: ::Xapi.problems - track.slugs,
        }
      end

      get '/tracks/:id/problems' do |id|
        track = find_track(id)
        pg :"track/problems", locals: { track: track }
      end

      get '/tracks/:id/todo' do |id|
        track = find_track(id)

        slugs = ::Xapi.problems - track.slugs
        pg :"track/todos", locals: {
          track: track,
          problems: slugs.map { |slug| ::Xapi.problems[slug] },
          implementations: ::Xapi.implementations,
        }
      end

      get '/tracks/:id/img/:filename' do |id, filename|
        track = find_track(id)

        img = track.img("img/#{filename}").tap do |image|
          image.path = "img/default_icon.png" unless image.exists?
        end

        send_file img.path, type: img.type
      end

      get '/tracks/:id/docs/img/:filename' do |id, filename|
        track = find_track(id)

        img = track.img("docs/img/#{filename}")
        unless img.exists?
          halt 404, {
            error: "No image %s in track '%s'" % [filename, id],
          }.to_json
        end

        send_file img.path, type: img.type
      end

      get '/tracks/:id/exercises/:slug' do |id, slug|
        implementation = find_implementation(id, slug)

        filename = "%s-%s.zip" % [id, slug]
        headers['Content-Type'] = "application/octet-stream"
        headers["Content-Disposition"] = "attachment;filename=%s" % filename

        implementation.zip.string
      end

      get '/tracks/:id/global' do |id|
        track = find_track(id)
        filename = "%s-%s.zip" % [id, "global"]
        headers['Content-Type'] = "application/octet-stream"
        headers["Content-Disposition"] = "attachment;filename=%s" % filename
        track.global_zip.string
      end

      # :files is either "readme" or "tests".
      get '/tracks/:id/exercises/:slug/:files' do |id, slug, files|
        track, implementation = find_track_and_implementation(id, slug)

        pg "exercise/#{files}".to_sym, locals: {
          track: track,
          implementation: implementation,
        }
      end
    end
  end
end
