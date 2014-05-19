module Xapi
  class Course
    attr_reader :data, :path

    def initialize(data, path)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
      @path = path
    end

    def in(language)
      lessons.find {|lesson| lesson.in?(language)} || Lesson.new(language, [], path)
    end

    def problems
      lessons.map(&:problems).flatten
    end

    def lessons
      data.map {|language, row| Lesson.new(language, row, path)}
    end
  end
end
