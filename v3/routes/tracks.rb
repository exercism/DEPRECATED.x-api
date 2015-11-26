module V3
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: { tracks: config.tracks }
      end

      get '/tracks/:id' do |id|
        pg :track, locals: { track: config.find(id) }
      end

      get '/tracks/:id/exercises/:slug/readme' do |id, slug|
        problem = config.find(id).find(slug)
        pg :readme, locals: { problem: problem }
      end
    end
  end
end
