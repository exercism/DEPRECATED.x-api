module Xapi
  class Lesson
    attr_reader :current_slugs, :progression

    def initialize(slugs, progression)
      @current_slugs = slugs
      @progression = progression
    end

    def exercises
      slugs.map {|slug| Exercise.new(progression.language, slug) }
    end

    private

    def slugs
      current_slugs.<<(progression.next(current_slugs)).compact
    end
  end
end
