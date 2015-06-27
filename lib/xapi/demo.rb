module Xapi
  # Demo grabs the first problem from each language track.
  module Demo
    def self.problems(config=Xapi::Config.new)
      config.tracks.select(&:active).map { |track| track.problems.first }
    end
  end
end
