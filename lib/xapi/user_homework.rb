module Xapi
  module UserHomework
    def self.exercises_for(key)
      data = ExercismIO.exercises_for(key)
      Homework.new(data, Xapi::Config.languages, Progression).exercises.sort_by {|exercise|
        [exercise.language, exercise.slug]
      }
    end

    def self.code_for(key)
      iterations = ExercismIO.code_for(key)
      iterations.map {|iteration| Iteration.new(iteration)}.sort_by {|iteration|
        [iteration.language, iteration.slug]
      }
    end

    def self.restore(key)
      exercises_for(key) + code_for(key)
    end
  end
end
