module Xapi
  class Progression
    attr_reader :language, :path

    def initialize(language, path)
      @language = language
      @path = path
    end

    def next(current)
      (slugs - current).first
    end

    def slugs
      File.open(file).map(&:chomp).reject(&irrelevant)
    end

    private

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
