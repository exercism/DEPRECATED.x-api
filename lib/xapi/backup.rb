module Xapi
  class Backup
    def self.restore(key)
      new(key).restore
    end

    attr_reader :key, :path
    def initialize(key, path=default_path)
      @key = key
      @path = path
    end

    def restore
      (exercises + code).sort_by(&Exercise::Name)
    end

    private

    def exercises
      course.exercises.reject(&:not_found?)
    end

    def course
      Course.new(data, path)
    end

    def data
      ExercismIO.exercises_for(key)
    end

    def code
      iterations.map {|iteration| Iteration.new(iteration)}
    end

    def iterations
      ExercismIO.code_for(key)
    end

    def default_path
      '.'
    end
  end
end
