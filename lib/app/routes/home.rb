module Xapi
  module Routes
    class Home < Sinatra::Base
      configure do
        set :root, './lib/app'
      end

      get '/' do
        haml :markdown, locals: {markdown: Xapi::Markdown.at('./CONTRIBUTING.md')}
      end
    end
  end
end
