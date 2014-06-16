module Xapi
  class Track
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def active
      data['active']
    end
    alias_method :active?, :active

    def slug
      data['slug']
    end

    def language
      data['language']
    end

    def problems
      problem_slugs.map {|problem_slug| Problem.new(slug, problem_slug, 'fresh', '.')}
    end

    def problem_ids
      problem_slugs.map {|problem_slug| [slug, problem_slug].join("/")}
    end

    def problem_slugs
      data['problems']
    end

    private

    def data
      @data ||= JSON.parse(File.read(file))
    end

    def file
      File.join(path, "config.json")
    end
  end
end
