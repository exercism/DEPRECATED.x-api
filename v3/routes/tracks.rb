module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {
          tracks: ::Rewrite.tracks,
          problems: ::Rewrite.problems,
        }
      end

      get '/tracks/:id' do |id|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        pg :track, locals: {
          track: track,
          todo: ::Rewrite.problems - track.slugs,
        }
      end

      get '/tracks/:id/problems' do |id|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        pg :"track/problems", locals: { track: track }
      end

      get '/tracks/:id/todo' do |id|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        slugs = ::Rewrite.problems - track.slugs
        pg :"track/todos", locals: {
          track: track,
          problems: slugs.map { |slug| ::Rewrite.problems[slug] },
          implementations: ::Rewrite.implementations,
        }
      end

      get '/tracks/:id/docs/img/:filename' do |id, filename|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        img = track.img(filename)
        unless img.exists?
          halt 404, {
            error: "No image %s in track '%s'" % [filename, id],
          }.to_json
        end

        send_file img.path, type: img.type
      end

      get '/tracks/:id/exercises/:slug/readme' do |id, slug|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, id],
          }.to_json
        end

        pg :"exercise/readme", locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/tracks/:id/exercises/:slug/tests' do |id, slug|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, id],
          }.to_json
        end

        pg :"exercise/tests", locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/tracks/:id/exercises/:slug' do |id, slug|
        track = ::Rewrite::Track.new(id, settings.tracks_path)
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
    end
  end
end
