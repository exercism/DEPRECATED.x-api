module Xapi
  class Config
    DEFAULT_PATH = "./problems"

    def self.languages
      tracks.select(&:active?).map(&:slug)
    end

    def self.tracks
      @tracks ||= Dir.glob("#{path}/*").map {|dir| Xapi::Track.new(dir)}.sort_by(&:slug)
    end

    def self.track_in(slug)
      tracks.find {|track| track.slug == slug}
    end

    def self.path
      DEFAULT_PATH
    end
  end
end
