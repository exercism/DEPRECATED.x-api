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
      (current_problems + upcoming_problems).reject(&:not_found?).sort_by(&Problem::Name)
    end

    private

    def current_problems
      course.problems.reject(&:completed?)
    end

    def course
      @course ||= Course.new(data, path)
    end

    def upcoming_problems
      progressions.map(&:next)
    end

    def progressions
      languages.map {|language| Progression.new(language, course.in(language).slugs, path)}
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end

    def default_path
      '.'
    end
  end
end
