module Xapi
  # Todo represents an unimplemented problem for a track.
  class Todo
    attr_reader :slug, :path

    def initialize(slug, path)
      @slug, @path = slug, path
    end

    def readme_url
      "https://github.com/exercism/x-common/blob/master/%s.md" % slug
    end

    def json_url
      f = File.join(path, "metadata", "%s.json" % slug)
      url = "https://github.com/exercism/x-common/blob/master/%s.json" % slug
      url if File.exist?(f)
    end

    def implementations
      Config.new(path).tracks.flat_map do |track|
        track.problems.select { |problem| problem.slug == slug }
      end
    end
  end
end
