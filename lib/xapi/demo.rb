module Xapi
  # Demo grabs the first problem from each language track.
  module Demo
    def self.problems
      Xapi::Config.tracks.select(&:active).map {|track| track.problems.first}
    end
  end
end
