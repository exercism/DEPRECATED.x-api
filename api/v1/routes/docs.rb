module V1
  module Routes
    class Docs < Core
      get '/docs/:track' do |id|
        pg :docs, locals:  { track: find_track(id) }
      end
    end
  end
end
