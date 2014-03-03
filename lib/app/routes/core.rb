module Xapi
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/app'
      end

      helpers Helpers::Guards

      get '/' do
        File.read(File.join(settings.public_folder, '/index.html'))
      end
    end
  end
end
