module Xapi
  module Routes
    class Tracks < Core
      get '/tracks' do
        pg :tracks, locals: {tracks: Xapi::Config.tracks}
      end
    end
  end
end
