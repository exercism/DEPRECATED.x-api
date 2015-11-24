module V1
  module Routes
    class Legacy < Core
      ERR_PLEASE_UPGRADE = "Please upgrade the exercism command-line client."
      ERR_DEMO = "We no longer support the demo command.\n" +
        "Check out the http://exercism.io/languages page to see what languages are available."

      get '/exercises' do
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/exercises/restore' do
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/exercises/:language' do
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/problems/demo' do
        halt 404, ERR_DOMO
      end
    end
  end
end
