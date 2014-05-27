module Xapi
  module Demo
    def self.problems
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
        'ruby' => 'leap',
        'scala' => 'bob'
      }.map {|language, slug| Problem.new(language, slug, 'fresh', '.')}
    end
  end
end
