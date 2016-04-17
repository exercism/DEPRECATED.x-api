module Xapi
  # Tracks is the collection of language tracks.
  class Tracks
    include Enumerable

    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      all.each do |track|
        yield track
      end
    end

    def [](id)
      by_id[id]
    end

    private

    def all
      @all ||= (Dir.entries(File.join(root, "tracks")) - %w(. ..)).map { |id|
        Track.new(id, root)
      }.sort_by(&:language)
    end

    def by_id
      @by_id ||= track_map
    end

    def track_map
      hash = Hash.new { |_, k| Track.new(k, root) }
      all.each do |track|
        hash[track.id] = track
      end
      hash
    end
  end
end
