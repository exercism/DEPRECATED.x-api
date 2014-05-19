module Xapi
  class Lesson
    attr_reader :language, :data, :path

    def initialize(language, data, path)
      @language = language
      @data = data
      @path = path
    end

    def in?(language)
      language == self.language
    end

    def slugs
      problems.map(&:slug)
    end

    def problems
      @problems ||= data.map {|row| Problem.new(language, row["slug"], row["state"], path) }
    end
  end
end
