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

    def deprecated
      data['deprecated']
    end

    def foregone
      data['foregone']
    end

    def docs
      @docs ||= Docs.new(track_path)
    end

    def find(slug)
      problems.find { |problem| problem.slug == slug } ||
        NullProblem.new(null_attributes(slug))
    end

    def todo
      metadata_slugs - slugs - deprecated - foregone
    end

    def todo_details
      todo.map { |slug| Todo.new(slug, root) }
    end

    private

    attr_reader :root, :track_path, :metadata_slugs

    def null_attributes(slug)
      {
        language: language,
        track_id: id,
        slug: slug,
        path: '.',
      }
    end

    def attributes(slug)
      {
        language: language,
        track_id: id,
        slug: slug,
        path: root,
        repository: repository,
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
