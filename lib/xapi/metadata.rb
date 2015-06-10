require 'yaml'
require_relative 'summary'

module Xapi
  # Metadata is the full list of available exercism problems.
  class Metadata
    REGEX_SLUG = %r{.*\/([^\/]*)\.yml}

    def self.load(path)
      metadata_dir = metadata_dir(path)
      new(dir: metadata_dir, slugs: slugs_in(metadata_dir))
    end

    def self.metadata_dir(dir)
      File.join(dir, "metadata")
    end
    private_class_method :metadata_dir

    def self.slugs_in(dir)
      Dir["#{dir}/*.yml"].map do |f|
        f[REGEX_SLUG, 1]
      end
    end
    private_class_method :slugs_in

    attr_reader :dir, :slugs
    def initialize(dir: default_dir, slugs: [])
      @dir = dir
      @slugs = slugs
    end

    def each
      summaries.each { |summary| yield summary }
    end

    def directory
      @directory ||= slugs.each_with_object({}) { |slug, table|
        table[slug] = Summary.load(slug, dir)
      }
    end

    def summaries
      @summary ||= directory.values
    end

    private

    def append(track_id)
      tracks << track_id
    end

    def tracks
      @tracks ||= []
    end
  end
end
