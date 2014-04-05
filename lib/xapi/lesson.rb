module Xapi
  class Lesson
    attr_reader :slugs, :progression

    def initialize(slugs, progression)
      @slugs = slugs
      @progression = progression
    end

    def exercises
      (current_exercises + [upcoming_exercise].compact)
    end

    def current_exercises
      slugs.map {|slug| Exercise.new(progression.language, slug) }
    end

    def upcoming_exercise
      if next_slug
        Exercise.new(progression.language, next_slug).fresh!
      end
    end

    private

    def next_slug
      progression.next(slugs)
    end
  end
end
