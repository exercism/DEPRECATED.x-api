module Xapi
  class Progression
    attr_reader :language, :current, :path

    def initialize(language, current=[], path='.')
      @language = language
      @current = current
      @path = path
    end

    def next
      Exercise.new(language, next_slug, 'fresh')
    end

    def slugs
      File.open(file).map(&:chomp).reject(&irrelevant)
    end

    private

    def next_slug
      (slugs - current).first || 'no-such-exercise'
    end

    def dir
      File.join(path, 'exercises', language)
    end

    def file
      File.join(dir, 'EXERCISES.txt')
    end

    def irrelevant
      Proc.new {|line| line.empty? || line =~ /^#/ }
    end
  end
end
