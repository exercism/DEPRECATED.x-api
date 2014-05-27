module Xapi
  class Config
    DEFAULT_PATH = "./problems"

    def self.languages
      tracks.select(&:active?).map(&:slug)
    end

    def self.tracks
      Dir.glob("#{DEFAULT_PATH}/*").map {|dir| Xapi::Track.new(dir)}.sort_by(&:slug)
    end
  end
end
