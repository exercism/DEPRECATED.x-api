module Xapi
  module Demo
    def self.problems
      Xapi::Config.tracks.select(&:active).map {|track| track.problems.first}
    end
  end
end
