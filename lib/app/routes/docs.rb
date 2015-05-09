module Xapi
  module Routes
    class Docs < Core
      get '/docs/:track' do |id|
        docs = Xapi::Config.find(id).docs
        halt 404, {
          error: "Documentation for track #{id} was not found.",
        }.to_json unless docs.available?
        pg :docs, locals:  { docs: docs }
      end
    end
  end
end
