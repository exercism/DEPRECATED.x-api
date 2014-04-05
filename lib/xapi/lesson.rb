module Xapi
  class Lesson
    attr_reader :language, :slugs

    def initialize(language, slugs)
      @language = language
      @slugs = slugs
    end

    def exercises
      slugs.map {|slug| Exercise.new(language, slug) }
    end
  end
end
