module Xapi
  # Config is a track-specific config.
  class Config
    DEFAULT_PATH = "."
    REPO_URL = "https://github.com/exercism/x-api"
    EXERCISM_URL = "https://github.com/exercism/exercism.io"
    CONTRIBUTING_URL = "%s/blob/master/CONTRIBUTING.md" % REPO_URL

    attr_reader :path

    def initialize(path=DEFAULT_PATH)
      @path = path
    end

    def track_ids
      tracks.select(&:active?).map(&:id)
    end

    def tracks
      @tracks ||= ids.map do |track_name|
        Xapi::Track.new(path, track_name, exercises)
      end.sort_by(&:id)
    end

    def find(id)
      tracks.find { |track| track.id == id } || NullTrack.new(id)
    end

    private

    def exercises
      Xapi::Metadata.load(path).slugs
    end

    def ids
      pattern = File.join(path, "tracks", "*")
      Dir.glob(pattern).map { |dir| File.basename(dir) }
    end
  end
end
