module Xapi
  class Backup
    def self.restore(key)
      new(key).restore
    end

    attr_reader :key
    def initialize(key)
      @key = key
    end

    def restore
      exercises + code
    end

    def exercises
      course.lessons.map(&:exercises).flatten.reject(&:not_found?).sort_by {|exercise|
        [exercise.language, exercise.slug]
      }
    end

    def course
      Course.new(data, Xapi::Config.languages)
    end

    def data
      ExercismIO.all_exercises_for(key)
    end

    def code
      iterations.map {|iteration| Iteration.new(iteration)}.sort_by {|iteration|
        [iteration.language, iteration.slug]
      }
    end

    def iterations
      ExercismIO.code_for(key)
    end
  end
end
