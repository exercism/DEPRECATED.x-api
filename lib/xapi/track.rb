module Xapi
  # Track is a collection of problems in a given language.
  class Track
    attr_reader :path
    def initialize(path)
      @path = path
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
      @docs ||= Docs.new(path)
    end

    def find(slug)
      problems.find(proc { Problem.new(attributes(slug)) }) { |problem|
        problem.slug == slug
      }
    end

    private

    def attributes(slug)
      {
        language: language,
        track_id: id,
        slug: slug,
        path: '.',
      }
    end

    def data
      @data ||= JSON.parse(File.read(file))
    end

    def file
      File.join(path, "config.json")
    end
  end
end
