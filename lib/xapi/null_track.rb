module Xapi
  # NullTrack is a non-existent track
  class NullTrack
    attr_reader :id
    def initialize(id)
      @id = id
    end

    def implemented?
      false
    end

    def active?
      false
    end

    def language
      id
    end

    def docs
      NullDocs.new
    end

    def todo
      []
    end

    def repository
      "https://github.com/exercism/x#{id}"
    end

    def problems
      []
    end

    def [](key)
      send(key)
    end

    def find(slug)
      NullProblem.new(language: 'Unknown', track_id: id, slug: slug, path: '.')
    end
  end
end
