module Xapi
  class Lesson
    attr_reader :slugs, :progression

    def initialize(slugs, progression)
      @slugs = slugs
      @progression = progression
    end

    def exercises
      (current_exercises + upcoming_exercises).compact
    end

    def current_exercises
      slugs.map {|slug| Exercise.new(progression.language, slug) }
    end

    def upcoming_exercises
      coming_up = []
      if next_slug
        coming_up << Exercise.new(progression.language, next_slug).fresh!
      end
      coming_up
    end

    private

    def next_slug
      progression.next(slugs)
    end
  end
end
