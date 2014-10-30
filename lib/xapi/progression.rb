module Xapi
  class Progression
    attr_reader :language, :current, :path

    def initialize(language, current=[], path)
      @language = language
      @current = current
      @path = path
    end

    def next
      # TODO: Use a real track here so we can get
      # the actual language name
      Problem.new(
        language: language,
        track_id: language,
        slug: next_slug,
        path: path,
      )
    end

    def slugs
      config["problems"]
    end

    private

    def config
      @config ||= JSON.parse(File.read(file))
    end

    def next_slug
      (slugs - current).first || 'no-such-problem'
    end

    def dir
      File.join(path, 'problems', language)
    end

    def file
      File.join(dir, 'config.json')
    end
  end
end
