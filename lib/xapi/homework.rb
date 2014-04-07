module Xapi
  class Homework
    attr_reader :key, :languages, :path
    def initialize(key, languages=Xapi::Config.languages, path=default_path)
      @key = key
      @languages = languages
      @path = path
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
      @course ||= Course.new(data, path)
    end

    def upcoming_exercises
      progressions.map(&:next)
    end

    def progressions
      languages.map {|language| Progression.new(language, course.in(language).slugs, path)}
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end

    def default_path
      '.'
    end
  end
end
