module Xapi
  module UserHomework
    def self.for(key)
      data = ExercismIO.exercises_for(key)
      Homework.new(data, Xapi::Config.languages, Progression).exercises.sort_by {|exercise| [exercise.language, exercise.slug]}
    end
  end
end
