module Xapi
  class Progression
    attr_reader :language, :current, :path

    def initialize(language, current=[], path)
      @language = language
      @current = current
      @path = path
    end

    def next
      Problem.new(language, next_slug, 'fresh', path)
    end

    def slugs
      File.open(file).map(&:chomp).reject(&irrelevant)
    end

    private

    def next_slug
      (slugs - current).first || 'no-such-problem'
    end

    def dir
      File.join(path, 'problems', language)
    end

    def file
      File.join(dir, 'PROBLEMS.txt')
    end

    def irrelevant
      Proc.new {|line| line.empty? || line =~ /^#/ }
    end
  end
end
