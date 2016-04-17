%w(
  track tracks
  problem problems
  implementation implementations
).each do |file|
  require_relative "rewrite/%s" % file
end

# Rewrite is a parallel implementation of the entire domain.
# We will slowly swap out the API endpoints to use the new code,
# then delete everything in lib/xapi and rename Rewrite to Xapi.
module Rewrite
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
