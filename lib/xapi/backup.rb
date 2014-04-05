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
      (exercises + code).sort_by(&Exercise::Name)
    end

    private

    def exercises
      course.exercises.reject(&:not_found?)
    end

    def course
      Course.new(data)
    end

    def data
      ExercismIO.all_exercises_for(key)
    end

    def code
      iterations.map {|iteration| Iteration.new(iteration)}
    end

    def iterations
      ExercismIO.code_for(key)
    end
  end
end
