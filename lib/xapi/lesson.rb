module Xapi
  class Lesson
    attr_reader :language, :data

    def initialize(language, data)
      @language = language
      @data = data
    end

    def in?(language)
      language == language
    end

    def slugs
      exercises.map(&:slug)
    end

    def exercises
      @exercises ||= data.map {|row| Exercise.new(language, row["slug"], row["state"]) }
    end
  end
end
