module Xapi
  class Course
    attr_reader :data, :languages

    def initialize(data, languages)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
      @languages = languages
    end

    def lessons
      languages.map {|language|
        Lesson.new(language, data[language])
      }
    end
  end
end
