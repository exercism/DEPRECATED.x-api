module Xapi
  # Config is a track-specific config.
  class Config
    DEFAULT_PATH = "./problems"
    REPO_URL = "https://github.com/exercism/x-api"
    EXERCISM_URL = "https://github.com/exercism/exercism.io"
    CONTRIBUTING_URL = "%s/blob/master/CONTRIBUTING.md" % REPO_URL

    def self.languages
      tracks.select(&:active?).map(&:id)
    end

    def self.tracks
      @tracks ||= dirs.map { |dir| Xapi::Track.new(dir) }.sort_by(&:id)
    end

    def self.find(id)
      tracks.find { |track| track.id == id } || NullTrack.new(id)
    end

    def self.path
      DEFAULT_PATH
    end

    def self.dirs
      Dir.glob("#{path}/*")
    end
  end
end
