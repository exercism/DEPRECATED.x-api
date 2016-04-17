module Xapi
  # Implementations is a collection of exercises in a specific language track.
  class Implementations
    include Enumerable

    attr_reader :track_id, :repo, :slugs, :root
    def initialize(track_id, repo, slugs, root)
      @track_id = track_id
      @repo = repo
      @slugs = slugs
      @root = root
    end

    def each
      all.each do |implementation|
        yield implementation
      end
    end

    def [](slug)
      by_slug[slug]
    end

    private

    def all
      @all ||= slugs.map { |slug|
        Implementation.new(track_id, repo, Problem.new(slug, root), root)
      }
    end

    def by_slug
      @by_slug ||= implementation_map
    end

    def implementation_map
      hash = Hash.new { |_, k|
        Implementation.new(track_id, repo, Problem.new(k, root), root)
      }
      all.each do |impl|
        hash[impl.problem.slug] = impl
      end
      hash
    end
  end
end
