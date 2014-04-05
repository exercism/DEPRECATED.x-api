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
        (lesson.exercises + [upcoming_exercise_in(lesson)].compact)
      }.flatten.reject(&:not_found?).sort_by(&name)
    end

    private

    def upcoming_exercise_in(lesson)
      progression = Progression.new(lesson.language)
      if progression.next(lesson.slugs)
        Exercise.new(progression.language, progression.next(lesson.slugs)).fresh!
      end
    end

    def name
      Proc.new {|exercise|
        [exercise.language, exercise.slug]
      }
    end

    def data
      ExercismIO.exercises_for(key)
    end

    def course
      Course.new(data, Xapi::Config.languages)
    end
  end
end
