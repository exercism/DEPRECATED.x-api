module Xapi
  class Homework
    attr_reader :key, :languages
    def initialize(key, languages=Xapi::Config.languages)
      @key = key
      @languages = languages
    end

    def exercises_in(language)
      exercises.select { |exercise| exercise.language == language }
    end

    def exercises
      (current_exercises + upcoming_exercises).reject(&:not_found?).sort_by(&Exercise::Name)
    end

    private

    def current_exercises
      course.exercises.reject(&:completed?)
    end

    def course
      @course ||= Course.new(data)
    end

    def upcoming_exercises
      progressions.map(&:next)
    end

    def progressions
      languages.map {|language| Progression.new(language, course.in(language).slugs)}
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end
  end
end
