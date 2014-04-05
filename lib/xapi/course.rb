module Xapi
  class Course
    attr_reader :data, :languages, :progression, :path

    def initialize(data, languages, progression, path=default_path)
      data.default_proc = Proc.new {|hash, language| hash[language] = []}
      @data = data
      @languages = languages
      @progression = progression
      @path = path
    end

    def lessons
      languages.map {|language|
        Lesson.new(data[language], progression.new(language, path))
      }
    end

    def default_path
      '.'
    end
  end
end
