module Xapi
  class Homework
    attr_reader :key
    def initialize(key)
      @key = key
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
      Xapi::Config.languages.map {|language|
        progression = Progression.new(language)
        slugs = course.exercises.map(&:slug)
        if progression.next(slugs)
          Exercise.new(language, progression.next(slugs)).fresh!
        end
      }
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end
  end
end
