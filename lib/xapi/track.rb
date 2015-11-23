module Xapi
  # Track is a collection of problems in a given language.
  class Track
    attr_reader :id
    def initialize(root, id, metadata_slugs=[])
      @root = root
      @id = id
      @track_path = File.join(root, "tracks", id)
      @metadata_slugs = metadata_slugs
    end

    def active
      data['active']
    end
    alias_method :active?, :active

    def implemented?
      problems.size > 0
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

    attr_reader :root, :track_path, :metadata_slugs

    def attributes(slug)
      {
        language: language,
        track_id: id,
        slug: slug,
        path: root,
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
