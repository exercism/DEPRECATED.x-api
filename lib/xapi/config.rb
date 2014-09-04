module Xapi
  class Config
    DEFAULT_PATH = "./problems"

    def self.languages
      tracks.select(&:active?).map(&:id)
    end

    def self.tracks
      @tracks ||= Dir.glob("#{path}/*").map {|dir| Xapi::Track.new(dir)}.sort_by(&:id)
    end

    def self.find(id)
      tracks.find {|track| track.id == id}
    end

    def self.path
      DEFAULT_PATH
    end
  end
end
