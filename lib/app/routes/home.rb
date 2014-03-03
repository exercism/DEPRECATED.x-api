module Xapi
  module Routes
    class Home < Core
      get '/' do
        File.read(File.join(settings.public_folder, '/index.html'))
      end
    end
  end
end
