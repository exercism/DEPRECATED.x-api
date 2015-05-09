module Xapi
  # NullTrack is a non-existent track
  class NullTrack
    attr_reader :id
    def initialize(id)
      @id = id
    end

    def find(slug)
      Problem.new(language: 'Unknown', track_id: id, slug: slug, path: '.')
    end

    def docs
      NullDocs.new
    end
  end
end
