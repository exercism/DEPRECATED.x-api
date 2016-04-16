module V1
  module Routes
    class Docs < Core
      get '/docs/:track' do |id|
        track = config.find(id)
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end

        pg :docs, locals:  { track: track }
      end
    end
  end
end
