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
      course.lessons.map {|lesson|
        (lesson.current_exercises + [lesson.upcoming_exercise].compact)
      }.flatten.reject(&:not_found?).sort_by(&name)
    end

    private

    def name
      Proc.new {|exercise|
        [exercise.language, exercise.slug]
      }
    end

    def data
      ExercismIO.exercises_for(key)
    end

    def course
      Course.new(data, Xapi::Config.languages, Progression)
    end
  end
end
