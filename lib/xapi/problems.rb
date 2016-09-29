module Xapi
  # Problems is the collection of problems that we have metadata for.
  class Problems
    include Enumerable

    SLUG_PATTERN = Regexp.new(".*\/([^\/]*)\.yml")

    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      all.each do |problem|
        yield problem
      end
    end

    def [](slug)
      by_slug[slug]
    end

    # rubocop:disable Style/OpMethod
    def -(slugs)
      (by_slug.keys - slugs).sort
    end

    private

    def all
      @all ||= problems + problems_in_deprecated_path
    end

    def problems_in_deprecated_path
      Dir["%s/metadata/*.yml" % root].sort.map { |f|
        Problem.new(f[SLUG_PATTERN, 1], root)
      }
    end

    def problems
      default_slugs.map { |slug| Problem.new(slug, root) }
    end

    def all_slugs
      Dir.glob("%s/metadata/exercises/*/" % root).sort
         .map { |f| File.basename(f) }
    end

    def default_slugs
      all_slugs.reject { |slug| deprecated?(slug) }
    end

    def deprecated?(slug)
      File.exist?(path_to_deprecated(slug))
    end

    def by_slug
      @by_slug ||= problem_map
    end

    def path_to_deprecated(slug)
      File.join(root, "metadata", "exercises", slug, ".deprecated")
    end

    def problem_map
      hash = Hash.new { |_, k| Problem.new(k, root) }
      all.each do |problem|
        hash[problem.slug] = problem
      end
      hash
    end
  end
end
