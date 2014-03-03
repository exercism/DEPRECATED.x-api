module Xapi
  module Routes
    class Home < Core
      get '/' do
        haml :markdown, locals: {markdown: Xapi::Markdown.at('./CONTRIBUTING.md')}
      end
    end
  end
end
