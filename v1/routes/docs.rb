module Xapi
  module Routes
    class Docs < Core
      get '/docs/:track' do |id|
        pg :docs, locals:  { docs: config.find(id).docs, track_id: id }
      end
    end
  end
end
