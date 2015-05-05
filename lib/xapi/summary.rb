module Xapi
  # Summary is the metadata for a single problem.
  class Summary
    def self.load(slug, dir)
      new(slug, YAML.load(File.read(File.join(dir, "#{slug}.yml"))))
    end

    attr_reader :slug, :blurb, :source, :source_url, :track_ids
    def initialize(slug, data)
      @track_ids = []
      @slug = slug
      data.each {|field, value|
        instance_variable_set(:"@#{field}", value)
      }
    end

    def append(track_id)
      @track_ids << track_id
    end
  end
end
