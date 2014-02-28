module Xapi
  module Demo
    def self.exercises
      {
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
      }.map {|language, slug| Exercise.new(language, slug)}
    end
  end
end
