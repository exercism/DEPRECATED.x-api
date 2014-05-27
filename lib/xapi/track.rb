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
      problem_ids.map {|id| Problem.new(slug, id, 'fresh', '.')}
    end

    def problem_ids
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
