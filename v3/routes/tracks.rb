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
        pg :"track/problems", locals: {track: track}
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
    end
  end
end
