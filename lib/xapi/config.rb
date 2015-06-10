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

    def languages
      tracks.select(&:active?).map(&:id)
    end

    def tracks
      @tracks ||= tracks_names.map do |track_name|
        Xapi::Track.new(path, track_name, exercices)
      end.sort_by(&:id)
    end

    def find(id)
      tracks.find { |track| track.id == id } || NullTrack.new(id)
    end

    private

    def exercices
      @exercices =  Xapi::Metadata.load(path).slugs
    end

    def tracks_names
      pattern = File.join(path, "problems", "*")
      Dir.glob(pattern).map { |dir| File.basename(dir) }
    end
  end
end
