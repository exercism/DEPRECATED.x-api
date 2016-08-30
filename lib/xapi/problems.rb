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
      Dir.glob("%s/metadata/exercises/**/" % root).sort
         .reject { |f| File.directory?(f) } # rejecting '.' and '..'
         .map { |f| Problem.new(File.basename(f), root) }
    end

    def by_slug
      @by_slug ||= problem_map
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
