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
      @problems ||= problem_slugs.map {|slug| Problem.new(problem_attributes(slug))}
    end

    def problem_slugs
      data['problems']
    end

    def find(slug)
      problems.find {|problem| problem.slug == slug} || Problem.new(problem_attributes(slug))
    end

    private

    def problem_attributes(slug)
      {
        language: language,
        track_id: self.slug,
        slug: slug,
        state: 'fresh',
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
