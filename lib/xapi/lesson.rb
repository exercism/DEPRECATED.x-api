module Xapi
  class Lesson
    attr_reader :slugs, :language

    def initialize(slugs, language)
      @slugs = slugs
      @language = language
    end

    def exercises
      slugs.map {|slug| Exercise.new(language, slug) }
    end
  end
end
