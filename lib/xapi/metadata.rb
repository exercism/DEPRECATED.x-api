require 'yaml'
require_relative 'summary'

module Xapi
  # Metadata is the full list of available exercism problems.
  class Metadata
    REGEX_SLUG = %r{.*\/([^\/]*)\.yml}

    def self.default_dir
      File.join(".", "metadata")
    end

    def self.load(dir=default_dir)
      new(dir: dir, slugs: slugs_in(dir))
    end

    def self.slugs_in(dir)
      Dir["#{dir}/*.yml"].map do |f|
        f[REGEX_SLUG, 1]
      end
    end

    attr_reader :dir, :slugs
    def initialize(dir: dir, slugs: slugs)
      @dir = dir
      @slugs = slugs
    end

    def each
      summaries.each { |summary| yield summary }
    end

    def directory
      @directory ||= slugs.each_with_object({}) { |slug, table|
        table[slug] = Summary.load(slug: slug, dir: dir)
      }
    end

    def summaries
      @summary ||= directory.values
    end

    def append(track_id)
      tracks << track_id
    end

    def tracks
      @tracks ||= []
    end
  end
end
