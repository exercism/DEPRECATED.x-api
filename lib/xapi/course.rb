module Xapi
  class Course
    attr_reader :data

    def initialize(data)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
    end

    def in(language)
      lessons.find {|lesson| lesson.in?(language)} || Lesson.new(language, [])
    end

    def exercises
      lessons.map(&:exercises).flatten
    end

    def lessons
      data.map {|language, row| Lesson.new(language, row)}
    end
  end
end
