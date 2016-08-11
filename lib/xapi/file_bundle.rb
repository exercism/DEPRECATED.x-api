require 'zip'
module Xapi
  # Module to return all the files in given path and zip them
  class FileBundle
    attr_reader :dir, :ignore_patterns
    def initialize(dir, ignore_patterns=[])
      @dir = dir
      @ignore_patterns = ignore_patterns
    end

    def create_zip
      Zip::OutputStream.write_buffer do |io|
        list_paths.each do |path|
          io.put_next_entry(path.relative_path_from(dir))
          io.print IO.read(path)
        end
        yield io if block_given?
      end
    end

    def list_paths
      Pathname.glob("#{dir}/**/*", File::FNM_DOTMATCH).reject {|file|
        file.directory? ||
          ignore_patterns.any? { |pattern| file.to_s =~ pattern }
      }.sort
    end
  end
end
