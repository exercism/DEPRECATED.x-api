module Xapi
  # Homework gets all of a user's currently pending problems.
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
        attributes = { track_id: language, language: language, path: path }
        slugs_in(language).map {|slug|
          Problem.new(attributes.merge(slug: slug))
        }.uniq + [next_in(language)]
      }.flatten.reject(&:not_found?)
    end

    private

    def slugs_in(language)
      Array(data[language]).map { |row| row["slug"] }
    end

    def next_in(language)
      Progression.new(language, slugs_in(language), path).next
    end

    def data
      @data ||= ExercismIO.exercises_for(key)
    end

    def default_path
      '.'
    end
  end
end
