module Xapi
  # Track is a collection of problems in a given language.
  class Track
    def initialize(path, track, metadata_slugs=[])
      @path = path
      @track = track
      @track_path = File.join(path, "problems", track)
      @metadata_slugs = metadata_slugs
    end

    def active
      data['active']
    end
    alias_method :active?, :active

    def id
      data['slug']
    end

    def repository
      data['repository']
    end

    def language
      data['language']
    end

    def problems
      @problems ||= slugs.map { |slug| Problem.new(attributes(slug)) }
    end

    def slugs
      data['problems']
    end

    def docs
      @docs ||= Docs.new(track_path)
    end

    def find(slug)
      problems.find(proc { Problem.new(attributes(slug)) }) { |problem|
        problem.slug == slug
      }
    end

    def todo
      metadata_slugs - slugs
    end

    private

    attr_reader :path, :track, :track_path, :metadata_slugs

    def attributes(slug)
      {
        language: language,
        track_id: id,
        slug: slug,
        path: path,
      }
    end

    def data
      @data ||= JSON.parse(File.read(file))
    end

    def file
      File.join(track_path, "config.json")
    end
  end
end
