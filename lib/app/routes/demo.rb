module Xapi
  module Routes
    class Demo < Sinatra::Application
      configure do
        set :root, './lib/app'
      end

      get '/demo' do
        exercises = {
          'clojure' => 'bob',
          'coffeescript' => 'bob',
          'elixir' => 'bob',
          'go' => 'leap',
          'haskell' => 'bob',
          'javascript' => 'bob',
          'objective-c' => 'bob',
          'ocaml' => 'bob',
          'perl5' => 'bob',
          'python' => 'bob',
          'ruby' => 'bob',
          'scala' => 'bob'
        }.map {|language, slug|
          Exercise.new(language, slug)
        }
        pg :exercises, locals: {exercises: exercises}
      end
    end
  end
end
