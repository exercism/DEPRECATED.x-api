module Xapi
  class Homework
    attr_reader :key, :languages, :path
    def initialize(key, languages=Xapi::Config.languages, path=default_path)
      @key = key
      @languages = languages
      @path = path
    end

    def problems_in(language)
      problems.select { |problem| problem.language == language }
    end

    def problems
      languages.map {|language|
        course.in(language).problems + [next_in(language)]
      }.flatten.reject(&:completed?).reject(&:not_found?)
    end

    private

    def course
      @course ||= Course.new(data, path)
    end

    def next_in(language)
      Progression.new(language, course.in(language).slugs, path).next
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end

    def default_path
      '.'
    end
  end
end
