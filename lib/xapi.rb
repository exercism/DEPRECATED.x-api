libraries = Dir[File.expand_path('../xapi/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end

# Xapi assembles Exercism language track data.
module Xapi
  if ENV["RACK_ENV"] == "test"
    ROOT = "./test/fixtures"
  else
    ROOT = "."
  end
  DEFAULT_PATH = "."
  REPO_URL = "https://github.com/exercism/x-api"
  EXERCISM_URL = "https://github.com/exercism/exercism.io"
  CONTRIBUTING_URL = "%s/blob/master/CONTRIBUTING.md" % REPO_URL

  def self.problems
    @problems ||= Problems.new(ROOT)
  end

  def self.tracks
    @tracks ||= Tracks.new(ROOT)
  end

  # rubocop:disable NegatedIf
  def self.implementations
    return @implementations if !!@implementations
    @implementations = Hash.new { |h, k| h[k] = [] }
    tracks.each do |track|
      track.implementations.each do |implementation|
        @implementations[implementation.problem.slug] << implementation
      end
    end
    @implementations
  end
end
