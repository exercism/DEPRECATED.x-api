module Xapi
  # Code represents all the non-readme portions of a problem.
  class Code
    attr_reader :dir
    def initialize(dir)
      @dir = dir
    end

    def glob
      Dir.glob("#{dir}/**/*", File::FNM_DOTMATCH) - ['.', '..']
    end

    def paths
      glob.reject(&dir_ey).reject(&example_ey).sort
    end

    def files
      paths.each_with_object({}) {|path, files|
        files[basename(path)] = File.read(path)
      }
    end

    private

    def basename(path)
      path.gsub("#{dir}/", "")
    end

    # Don't name this dir?, because it returns a proc,
    # which is always truthy.
    def dir_ey
      ->(path) { File.directory?(path) }
    end

    def example_ey
      ->(path) { path =~ /example/i }
    end
  end
end
