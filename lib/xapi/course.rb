module Xapi
  class Course
    attr_reader :data, :languages, :progression, :path

    def initialize(data, languages, progression)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
      @languages = languages
      @progression = progression
    end

    def lessons
      languages.map {|language|
        Lesson.new(data[language], progression.new(language))
      }
    end
  end
end
