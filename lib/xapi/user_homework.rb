module Xapi
  module UserHomework
    def self.exercises_for(key)
      extract ExercismIO.exercises_for(key)
    end

    def self.all_exercises_for(key)
      extract ExercismIO.all_exercises_for(key)
    end

    def self.all_exercises_by_language_for(key, language)
      exercises = extract ExercismIO.exercises_for(key)
      exercises.select { |exercise| exercise.language == language }
    end

    def self.code_for(key)
      iterations = ExercismIO.code_for(key)
      iterations.map {|iteration| Iteration.new(iteration)}.sort_by {|iteration|
        [iteration.language, iteration.slug]
      }
    end

    def self.restore(key)
      all_exercises_for(key) + code_for(key)
    end

    def self.extract(data)
      Homework.new(data, Xapi::Config.languages, Progression).exercises.reject(&:not_found?).sort_by {|exercise|
        [exercise.language, exercise.slug]
      }
    end
  end
end
