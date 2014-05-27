module Xapi
  module Routes
    class Problems < Core
      get '/problems/:language' do |language|
        track = Xapi::Config.track_in(language)
        pg :exercises, locals: {exercises: track.problems}
      end
    end
  end
end
