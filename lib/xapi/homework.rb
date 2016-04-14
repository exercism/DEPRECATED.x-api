module Xapi
  # Homework gets all of a user's currently pending problems,
  # marking any new ones as fetched.
  # TODO: this class violates command/query separation. Refactor.
  class Homework
    attr_reader :key, :languages, :path
    def initialize(key, languages, path)
      @key = key
      @languages = languages
      @path = path
    end

    def problems_in(language)
      problems = slugs_in(language).map do |slug|
        Problem.new track_id: language,
                    language: language,
                    path: path,
                    slug: slug
      end
      problems << next_in(language)
      problems.reject(&:not_found?)
    end

    def problems
      languages.flat_map { |language| problems_in language }
    end

    private

    def slugs_in(language)
      Array(data[language]).map { |row| row["slug"] }
    end

    def next_in(language)
      mark_as_fetched Progression.new(language, slugs_in(language), path).next
    end

    def mark_as_fetched(problem)
      unless problem.not_found?
        ExercismIO.fetch(key, problem.language, problem.slug)
      end
      problem
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end
  end
end
