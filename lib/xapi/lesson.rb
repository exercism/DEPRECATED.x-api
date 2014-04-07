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
      exercises.map(&:slug)
    end

    def exercises
      @exercises ||= data.map {|row| Exercise.new(language, row["slug"], row["state"], path) }
    end
  end
end
