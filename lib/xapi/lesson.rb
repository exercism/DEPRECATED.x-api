module Xapi
  class Lesson
    attr_reader :language, :data, :path

    def initialize(language, data, path)
      @language = language
      @data = data
      @path = path
    end

    def in?(language)
      language == self.language
    end

    def slugs
      problems.map(&:slug)
    end

    def problems
      @problems ||= data.map {|row| Problem.new(problem_from(row)) }
    end

    private

    def problem_from(row)
      {
        language: language, # TODO: get real language name
        track_id: language,
        path: path,
        slug: row["slug"],
        state: row["state"],
      }
    end
  end
end
