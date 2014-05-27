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
