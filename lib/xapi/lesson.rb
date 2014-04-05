module Xapi
  class Lesson
    attr_reader :language, :data

    def initialize(language, data)
      @language = language
      @data = data
    end

    def exercises
      data.map {|row| Exercise.new(language, row["slug"], row["state"]) }
    end
  end
end
