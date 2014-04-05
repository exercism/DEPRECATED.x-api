module Xapi
  class Course
    attr_reader :data

    def initialize(data)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
    end

    def lessons
      data.map {|language, slugs|
        Lesson.new(language, data[language])
      }
    end
  end
end
