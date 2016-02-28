module Xapi
  # Todo represents an unimplemented problem for a track.
  class Todo
    attr_reader :slug, :path

    def initialize(slug, path)
      @slug, @path = slug, path
    end

    def readme
      Readme.new(slug, path)
    end

    def implemented_examples
      Config.new(path).tracks.flat_map do |track|
        track.problems.select { |problem| problem.slug == slug }
      end
    end
  end
end
